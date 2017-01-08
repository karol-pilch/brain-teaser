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
	
	// Interesting points around the screen.
	// Warning: The X and Y of the screen don't change with the position change.
	class var offScreenRightPosition: CGPoint {
		return CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
	}
	
	class var offScreenLeftPosition: CGPoint {
		return CGPoint(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
	}
	
	class var screenCenterPosition: CGPoint {
		return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
	}
	
	var originalConstants: [CGFloat]
	var constraints: [NSLayoutConstraint]!
	
	init(constraints: [NSLayoutConstraint]) {
		self.constraints = constraints
		self.originalConstants = [CGFloat]()
		for con in constraints {
			originalConstants.append(con.constant)
		}
	}
	
	func animateOnScreen() {
		for con in constraints {
			// HERE: 16:30 of lesson 6.
		}
	}
}
