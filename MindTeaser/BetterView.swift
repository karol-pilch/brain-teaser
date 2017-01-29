//
//  BetterView.swift
//  MindTeaser
//
//  Created by Karol Pilch on 29/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

@IBDesignable
class BetterView: UIView {

	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			layer.cornerRadius = cornerRadius
			setNeedsLayout()
		}
	}
	
	override func awakeFromNib() {
		layer.cornerRadius = cornerRadius
		setNeedsLayout()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		layer.cornerRadius = cornerRadius
		setNeedsLayout()
	}

}
