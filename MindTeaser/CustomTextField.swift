//
//  CustomTextField.swift
//  MindTeaser
//
//  Created by Karol Pilch on 08/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
	
	// The inset ('padding') of the text in the field.
	@IBInspectable var inset: CGFloat = 0
	
	// Round corners!
	@IBInspectable var cornerRadius: CGFloat = 5.0 {
		didSet {
			setupView()
		}
	}
	
	// Applies our inset to a bounding rectangle.
	private func applyInset(forRect bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: inset, dy: inset)
	}
	
	// Applies overriden properties to the view.
	private func setupView() {
		self.layer.cornerRadius = cornerRadius
	}
	
	// The rectangle for text when it's not being edited.
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return applyInset(forRect: bounds)
	}
	
	// The rectangle for text when it's being edited.
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return applyInset(forRect: bounds)
	}
	
	override func awakeFromNib() {
		setupView()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupView()
	}
}
