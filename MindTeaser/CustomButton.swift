//
//  CustomButton.swift
//  MindTeaser
//
//  Created by Karol Pilch on 08/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit
import pop

@IBDesignable
class CustomButton: UIButton {
	
	// Round corners!
	@IBInspectable var cornerRadius: CGFloat = 3.0 {
		didSet {
			setupView()
		}
	}
	
	// Custom font color.
	@IBInspectable var fontColor: UIColor = UIColor.white {
		didSet {
			setupView()
		}
	}
	
	// Prepare when loading from nib:
	override func awakeFromNib() {
		setupView()
	}
	
	// Prepare for Interface Builder:
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupView()
	}
	
	
	// Applies custom metrics to the view.
	private func setupView() {
		// 1. Apply custom metrics:
		self.tintColor = fontColor
		self.layer.cornerRadius = cornerRadius
		
		// 2. Register animation for events:
		
		// Make small when touch enters:
		self.addTarget(self, action: #selector(CustomButton.scaleToSmall), for: .touchDown)
		self.addTarget(self, action: #selector(CustomButton.scaleToSmall), for: .touchDragEnter)
		
		// Spring when touch ends:
		self.addTarget(self, action: #selector(CustomButton.scaleAnimation), for: .touchUpInside)
		
		// Make normal when touch leaves without ending:
		self.addTarget(self, action: #selector(CustomButton.scaleDefault), for: .touchDragExit)
	}
	
	/***** POP *****/
	func scaleToSmall() {
		let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
		scaleAnim?.toValue = CGSize(width: 0.95, height: 0.95)
		self.layer.pop_add(scaleAnim, forKey: "layerScaleSmallAnimation")
	}
	
	func scaleAnimation() {
		let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
		scaleAnim?.velocity = CGSize(width: 3.0, height: 3.0)
		scaleAnim?.toValue = CGSize(width: 1.0, height: 1.0)
		scaleAnim?.springBounciness = 18
		self.layer.pop_add(scaleAnim, forKey: "layerScaleSprintAnimation")
	}
	
	func scaleDefault() {
		let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
		scaleAnim?.toValue = CGSize(width: 1.0, height: 1.0)
		self.layer.pop_add(scaleAnim, forKey: "layerScaleDefaultAnimation")
	}
	
}
