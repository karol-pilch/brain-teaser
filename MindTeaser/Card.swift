//
//  Card.swift
//  MindTeaser
//
//  Created by Karol Pilch on 16/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

// @IBDesignable
class Card: UIView {
	
	// MARK: Image file handling
	
	let filenames = ["grin", "hearts", "smile_eyes", "smile", "smirk", "teeth", "tongue"]
	var currentImageIndex: Int = 0
	@IBOutlet weak var imageView: UIImageView!
	
	func selectShape() {
		currentImageIndex = Int(arc4random_uniform(UInt32(filenames.count)))
		let imageName = filenames[currentImageIndex]
		if let newImage = UIImage(named: imageName) {
			imageView.image = newImage
		}
	}
	
	// MARK: Custom looks
	
	@IBInspectable var cornerRadius: CGFloat = 3.0 {
		didSet {
			setupView()
		}
	}
	
	@IBInspectable var shadowColor: UIColor = UIColor.black {
		didSet {
			setupView()
		}
	}
	
	@IBInspectable var shadowRadius: CGFloat = 5.0 {
		didSet {
			setupView()
		}
	}
	
	@IBInspectable var shadowOffsetX: CGFloat = 1.0 {
		didSet {
			setupView()
		}
	}
	
	@IBInspectable var shadowOffsetY: CGFloat = 1.0 {
		didSet {
			setupView()
		}
	}
	
	@IBInspectable var shadowOpacity: Float = 0.3 {
		didSet {
			setupView()
		}
	}
	
	
	func setupView() {
		// Corner radius:
		self.layer.cornerRadius = cornerRadius
		
		// Shadow:
		self.layer.shadowColor = shadowColor.cgColor
		self.layer.shadowRadius = shadowRadius
		self.layer.shadowOpacity = shadowOpacity
		self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
		
		self.setNeedsDisplay()
	}
	
	override func awakeFromNib() {
		setupView()
		selectShape()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupView()
		selectShape()
	}
}
