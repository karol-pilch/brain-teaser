//
//  Card.swift
//  MindTeaser
//
//  Created by Karol Pilch on 16/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

class Card: UIView {
	
	// MARK: Image file handling
	
	let filenames = ["grin", "hearts", "smile_eyes", "smile", "smirk", "teeth", "tongue"]
	var currentImageIndex: Int = 0
	@IBOutlet weak var imageView: UIImageView!
	
	func selectShape() {
		currentImageIndex = Int(arc4random_uniform(UInt32(filenames.count)))
		imageView.image = UIImage(named: filenames[currentImageIndex])
	}
	
	// MARK: Custom looks
	
	@IBInspectable var cornerRadius: CGFloat = 3.0 {
		didSet {
			setupView()
		}
	}
	
	@IBInspectable var shadowColor: CGColor = UIColor.black.cgColor {
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
	
	
	func setupView() {
		// Corner radius:
		self.layer.cornerRadius = cornerRadius
		
		// Shadow:
		self.layer.shadowColor = shadowColor
		self.layer.shadowRadius = shadowRadius
		self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
		
		self.setNeedsLayout()
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
