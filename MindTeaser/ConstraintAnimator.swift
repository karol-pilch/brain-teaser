//
//  AnimationEngine.swift
//  MindTeaser
//
//  Created by Karol Pilch on 08/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit
import pop

// Provides uniform animations for constraints.
class ConstraintAnimator {
	
	// Screen sides
	enum HorizontalScreenSide {
		case Left
		case Right
	}
	
	// MARK: Managed constraints:
	typealias PersistentConstraint = (constraint: NSLayoutConstraint, originalConstant: CGFloat)
	typealias ManagedConstraintIndex = Int
	
	private var currentIndex: ManagedConstraintIndex = 0
	private var managedConstraints: [Int: [PersistentConstraint]] = [Int: [PersistentConstraint]]()
	
	// Adds the constraints to storage.
	func add(constraints: [NSLayoutConstraint]) -> ManagedConstraintIndex {
		currentIndex += 1
		var newBunch = [PersistentConstraint]()
		for con in constraints {
			newBunch.append((constraint: con, originalConstant: con.constant))
		}
		managedConstraints[currentIndex] = newBunch
		return currentIndex
	}
	
	// Removes the constraint set from storage.
	func removeConstraints(at index:ManagedConstraintIndex) -> [PersistentConstraint]? {
		return managedConstraints.removeValue(forKey: index)
	}
	
	// MARK: Animation
	var springBounciness: CGFloat = 12.0
	var springSpeed: CGFloat = 12.0
	var frictionDelta: CGFloat = 8.0
	
	var defaultDelay: Double = 0.8
	
	init() {}
	
	init(withBounciness bounciness: CGFloat, speed: CGFloat, frictionDelta: CGFloat) {
		self.springBounciness = bounciness
		self.springSpeed = speed
		self.frictionDelta = frictionDelta
	}
	
	// Helper: Creates a uniform POP animation.
	private func createMoveAnim(n: Int = 0) -> POPSpringAnimation? {
		let anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
		anim?.springBounciness = self.springBounciness
		anim?.springSpeed = self.springSpeed
		anim?.dynamicsFriction += CGFloat(n) * frictionDelta
		
		return anim
	}
	
	// Helper: Calculates the dispatch deadline for a delay, from now.
	private func calcDeadline(for delay: Double?) -> DispatchTime {
		let d = delay ?? defaultDelay
		return DispatchTime.now() + DispatchTimeInterval.nanoseconds(Int(Double(NSEC_PER_SEC) * d))
	}
	
	// Helper: Calculates the off-screen position for a given side.
	private func offScreenPosition(for side: HorizontalScreenSide) -> CGFloat {
		return UIScreen.main.bounds.width * (side == .Left ? -1 : 1)
	}
	
	
	// Hides the constraints away so that they can be animated onto the screen.
	func hide(at index: ManagedConstraintIndex, on side: HorizontalScreenSide = .Left) {
		if let constraints = managedConstraints[index] {
			for con in constraints {
				con.constraint.constant = offScreenPosition(for: side)
			}
		}
	}
	
	// Convenience overload for the other hide that first adds all constraints to the managedConstraints.
	func hide(constraints: [NSLayoutConstraint], on side: HorizontalScreenSide = .Left) -> ManagedConstraintIndex {
		let index = add(constraints: constraints)
		hide(at: index)
		return index
	}
	
	
	// Animates a bunch of constraints onto screen. Hides them away first.
	func animateHorizontallyOnScreen(constraintsAt index: ManagedConstraintIndex, from side: HorizontalScreenSide = .Left, after delay: Double? = nil, withCallback callback: (() -> ())? = nil) {
		
		// Hide first:
		hide(at: index, on: side)
		
		// Then animate on:
		if let constraints = managedConstraints[index] {
			var i = 0
			for con in constraints {
				// Create animation and schedule to run it:
				let anim = createMoveAnim(n: i)
				anim?.toValue = con.originalConstant
				
				if let completionCallback = callback {
					anim?.completionBlock = {(_: POPAnimation?, _: Bool) -> Void in
						completionCallback()
					}
				}
				
				DispatchQueue.main.asyncAfter(deadline: calcDeadline(for: delay)) {
					con.constraint.pop_add(anim, forKey: "moveOnScreen")
				}
				i += 1
			}
		}
	}
	
	// Convenience overload for the other function.
	func animateHorizontallyOnScreen(constraints: [NSLayoutConstraint], from side: HorizontalScreenSide = .Left, after delay: Double? = nil, withCallback callback: (() -> ())? = nil) -> ManagedConstraintIndex {
		let index = add(constraints: constraints)
		animateHorizontallyOnScreen(constraintsAt: index, from: side, after: delay)
		return index
	}
	
	// Moves a bunch of constraints off screen.
	func animateHorizontallyOffScreen(constraintsAt index: ManagedConstraintIndex, to side: HorizontalScreenSide = .Right, after delay: Double? = nil, withCallback callback: (() -> ())? = nil) {
		if let constraints = managedConstraints[index] {
			var i = 0
			for con in constraints {
				let anim = createMoveAnim(n: i)
				anim?.toValue = offScreenPosition(for: side)
				
				if let completionCallback = callback {
					anim?.completionBlock = {(_: POPAnimation?, _: Bool) -> Void in
						completionCallback()
					}
				}
				
				DispatchQueue.main.asyncAfter(deadline: calcDeadline(for: delay)) {
					con.constraint.pop_add(anim, forKey: kPOPLayoutConstraintConstant)
				}
				
				i += 1
			}
		}
	}
	
	// Convenience overload for the above. First adds the bunch of constraints to storage.
	func animateHorizontallyOffScreen(constraints: [NSLayoutConstraint], to side: HorizontalScreenSide = .Right, after delay: Double? = nil, withCallback callback: (() -> ())? = nil) -> ManagedConstraintIndex {
		let index = add(constraints: constraints)
		animateHorizontallyOffScreen(constraintsAt: index, to: side, after: delay, withCallback: callback)
		return index
	}
	
}
