//
//  CustomButton.swift
//  MindTeaser
//
//  Created by Karol Pilch on 08/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

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
		self.tintColor = fontColor
		self.layer.cornerRadius = cornerRadius
	}
}
