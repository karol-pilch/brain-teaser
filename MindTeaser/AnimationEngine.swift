//
//  AnimationEngine.swift
//  MindTeaser
//
//  Created by Karol Pilch on 08/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
	
	// Store the constraints and move them off screen.
	init(constraints: [NSLayoutConstraint]) {
		self.constraints = [(constraint: NSLayoutConstraint, originalConstant: CGFloat)]()
		
		for con in constraints {
			self.constraints.append((constraint: con, originalConstant: con.constant))
			con.constant = AnimationEngine.offScreenRightPosition.x
		}
	}

	// MARK: Points around the screen

	// Interesting points around the screen.
	// Warning: The X and Y of the screen don't change with the orientation change.
	class var offScreenRightPosition: CGPoint {
		return CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
	}
	
	class var offScreenLeftPosition: CGPoint {
		return CGPoint(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
	}
	
	class var screenCenterPosition: CGPoint {
		return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
	}
	
	// MARK: Animation
	
	// Storing the constraints with their original constants:
	var constraints: [(constraint: NSLayoutConstraint, originalConstant: CGFloat)]
	
	// Default delay for the animation.
	static let defaultDelay = 0.8
	
	// Animates the added constraints from off-screen position to their original positions.
	func animateOnScreen(delay: Double = AnimationEngine.defaultDelay) {
		
		let wait = DispatchTimeInterval.nanoseconds(Int(Double(NSEC_PER_SEC) * delay))
		
		DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
			var i = 0
			for con in self.constraints {
				let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
				moveAnim?.toValue = con.originalConstant
				
				// Configure springiness
				moveAnim?.springBounciness = 12.0
				moveAnim?.springSpeed = 12.0
				
				// Add more friction for each element:
				moveAnim?.dynamicsFriction += CGFloat(8 * i)
				
				// Start the animation!
				con.constraint.pop_add(moveAnim, forKey: "moveOnScreen")
				i += 1
			}
		}
	}
}

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
	
	static let defaultDelay: Double = 0.8
	
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
	private func calcDeadline(for delay: Double) -> DispatchTime {
		return DispatchTime.now() + DispatchTimeInterval.nanoseconds(Int(Double(NSEC_PER_SEC) * delay))
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
	func animateHorizontallyOnScreen(constraintsAt index: ManagedConstraintIndex, from side: HorizontalScreenSide = .Left, after delay: Double = ConstraintAnimator.defaultDelay) {
		
		// Hide first:
		hide(at: index, on: side)
		
		// Then animate on:
		if let constraints = managedConstraints[index] {
			var i = 0
			for con in constraints {
				// Create animation and schedule to run it:
				let anim = createMoveAnim(n: i)
				anim?.toValue = con.originalConstant
				
				DispatchQueue.main.asyncAfter(deadline: calcDeadline(for: delay)) {
					con.constraint.pop_add(anim, forKey: "moveOnScreen")
				}
				i += 1
			}
		}
	}
	
	// Convenience overload for the other function.
	func animateHorizontallyOnScreen(constraints: [NSLayoutConstraint], from side: HorizontalScreenSide = .Left, after delay: Double = ConstraintAnimator.defaultDelay) -> ManagedConstraintIndex {
		let index = add(constraints: constraints)
		animateHorizontallyOnScreen(constraintsAt: index, from: side, after: delay)
		return index
	}
	
	// Moves a bunch of constraints off screen.
	func animateHorizontallyOffScreen(constraintsAt index: ManagedConstraintIndex, to side: HorizontalScreenSide = .Right, after delay: Double = ConstraintAnimator.defaultDelay) {
		if let constraints = managedConstraints[index] {
			var i = 0
			for con in constraints {
				let anim = createMoveAnim(n: i)
				anim?.toValue = offScreenPosition(for: side)
				
				DispatchQueue.main.asyncAfter(deadline: calcDeadline(for: delay)) {
					con.constraint.pop_add(anim, forKey: kPOPLayoutConstraintConstant)
				}
				
				i += 1
			}
		}
	}
	
	// Convenience overload for the above. First adds the bunch of constraints to storage.
	func animateHorizontallyOffScreen(constraints: [NSLayoutConstraint], to side: HorizontalScreenSide = .Right, after delay: Double = ConstraintAnimator.defaultDelay) -> ManagedConstraintIndex {
		let index = add(constraints: constraints)
		animateHorizontallyOffScreen(constraintsAt: index, to: side, after: delay)
		return index
	}
	
}
