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
	
	// MARK: View setup:
	@IBOutlet weak var correctLabel: UILabel!
	@IBOutlet weak var incorrectLabel: UILabel!
	
	
	// Data to display
	var correctCount: Int = 0
	var incorrectCount: Int = 0
	
	
	// Configuration:
	let resultInitialOpacity: Float = 0.3
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		correctLabel.text = String(correctCount)
		incorrectLabel.text = String(incorrectCount)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		prepareForAnimation()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		showNumbers()
	}
	
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.portrait
	}
	
	
	// MARK: Animations
	
	func prepareForAnimation() {
		// Prepare the result numbers:
//		correctLabel.layer.opacity = resultInitialOpacity
//		incorrectLabel.layer.opacity = resultInitialOpacity
		
		for label in [correctLabel, incorrectLabel] {
			let rotate = CATransform3DMakeRotation(CGFloat.pi * -30 / 180, 0, 0, 1)
			label!.layer.transform = rotate
		}
	}
	
	// Animates the numbers to show them.
	func showNumbers() {
		
		// HERE: What's going on?
		let popUpAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
		popUpAnim?.toValue = 0
		popUpAnim?.springBounciness = 15
		popUpAnim?.springSpeed = 5
		
		correctLabel.pop_add(popUpAnim, forKey: "Rotate")
	}
	
	// Animates the summary view.
	func showSummary() {
		
	}
}
