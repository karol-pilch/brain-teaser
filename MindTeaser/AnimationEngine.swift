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

	// Unused for now - delete if not needed.
	// @todo
	struct PersistentConstraint {
		let constraint: NSLayoutConstraint
		let originalConstant: CGFloat
		
		init(_ constraint: NSLayoutConstraint) {
			self.constraint = constraint
			self.originalConstant = constraint.constant
		}
	}
	
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
	
	// Storing the constraints with their original constants:
	var constraints: [(constraint: NSLayoutConstraint, originalConstant: CGFloat)]
	
	// Store the constraints and move them off screen.
	init(constraints: [NSLayoutConstraint]) {
		self.constraints = [(constraint: NSLayoutConstraint, originalConstant: CGFloat)]()
		
		for con in constraints {
			self.constraints.append((constraint: con, originalConstant: con.constant))
			con.constant = AnimationEngine.offScreenRightPosition.x
		}
	}
	
	static let defaultDelay = 0.8
	
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
				
				moveAnim?.dynamicsFriction += CGFloat(8 * i)
				
				con.constraint.pop_add(moveAnim, forKey: "moveOnScreen")
				i += 1
			}
		}
	}
}

