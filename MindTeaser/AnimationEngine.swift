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

