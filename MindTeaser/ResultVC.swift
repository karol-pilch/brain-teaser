//
//  ResultVC.swift
//  MindTeaser
//
//  Created by Karol Pilch on 29/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

/*

To do:

* Make the numbers pop up from nothingness
* Make the pink view drop down from the top after a second
* Make the pink view say meaningful things.

*/

import UIKit
import pop

class ResultVC: UIViewController {
	
	enum Result {
		case Amazing
		case VeryGood
		case Poor
		case Bad
	}
	
	// MARK: View setup:
	@IBOutlet weak var correctLabel: UILabel!
	@IBOutlet weak var incorrectLabel: UILabel!

	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var summaryImage: UIImageView!
	
	// Data to display
	var correctCount: Int = 0
	var incorrectCount: Int = 0
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Show the correct information in labels:
		correctLabel.text = String(correctCount)
		incorrectLabel.text = String(incorrectCount)
		
		// Show the summery:
		let result: Result
		
		if correctCount > 60 && incorrectCount <= 1 {
			result = .Amazing
		} else if incorrectCount <= 5 {
			result = .VeryGood
		} else if incorrectCount <= 10 {
			result = .Poor
		} else {
			result = .Bad
		}
		
		switch result {
		case .Amazing:
			summaryLabel.text = "You are amazing!"
			summaryImage.image = #imageLiteral(resourceName: "hearts")
			
		case .VeryGood:
			summaryLabel.text = "That was very good!"
			summaryImage.image = #imageLiteral(resourceName: "smile_eyes")
			
		case .Poor:
			summaryLabel.text = "You can do better!"
			summaryImage.image = #imageLiteral(resourceName: "tongue")
			
		case .Bad:
			summaryLabel.text = "That was pretty bad..."
			summaryImage.image = #imageLiteral(resourceName: "teeth")
		}
	}


	override func viewWillAppear(_ animated: Bool) {
		prepareForAnimation()
	}

	
	override func viewDidAppear(_ animated: Bool) {
		showNumbers()
		showSummary()
	}


	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.portrait
	}


	// MARK: Animations
	@IBOutlet weak var summaryBottom: NSLayoutConstraint!
	
	// Config:
	let initialLabelAngle: CGFloat = -45.0
	let fadeInDuration: TimeInterval = 0.2
	
	let labelShowDelay: TimeInterval = 0.3
	let summaryDelay: TimeInterval = 0.8
	
	func prepareForAnimation() {
		// Prepare the result numbers:
		correctLabel.layer.opacity = 0.0
		incorrectLabel.layer.opacity = 0.0
		
		for label in [correctLabel, incorrectLabel] {
			let rotate = CATransform3DMakeRotation(CGFloat.pi * initialLabelAngle / 180, 0, 0, 1)
			label!.layer.transform = rotate
		}
		
		// Move the summary off screen:
		summaryBottom.constant = UIScreen.main.bounds.height
	}
	
	// Creates an animation to add to a label to wiggle it.
	func makeWiggleAnim() -> POPSpringAnimation? {
		let anim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
		anim?.toValue = 0.0
		anim?.springBounciness = 20
		anim?.springSpeed = 10
		anim?.velocity = 60
		return anim
	}
	
	// Animates the numbers to show them.
	func showNumbers() {
		
		let wiggleAnim = makeWiggleAnim()
		
		// Show and wiggle:
		correctLabel.layer.pop_add(wiggleAnim, forKey: "Rotate")
		UIView.animate(withDuration: fadeInDuration) {
			self.correctLabel.layer.opacity = 1.0
		}
		
		// Show and wiggle after a second:
		let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(floor(labelShowDelay * 1000)))
		DispatchQueue.main.asyncAfter(deadline: deadline) {
			UIView.animate(withDuration: self.fadeInDuration) {
				self.incorrectLabel.layer.opacity = 1.0
			}
			let laterAnim = self.makeWiggleAnim()
			self.incorrectLabel.layer.pop_add(laterAnim, forKey: "wiggle")
		}
	}
	
	// Animates the summary view.
	func showSummary() {
		// Configure the animation:
		let dropAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
		dropAnim?.springSpeed = 7.0
		dropAnim?.springBounciness = 17.0
		dropAnim?.toValue = 0.0
		dropAnim?.velocity = 0
		dropAnim?.dynamicsFriction += 3.0
		
		let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(floor(summaryDelay * 1000)))
		DispatchQueue.main.asyncAfter(deadline: deadline) { 
			self.summaryBottom.pop_add(dropAnim, forKey: "drop")
		}
	}
}
