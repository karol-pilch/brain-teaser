//
//  ViewController.swift
//  MindTeaser
//
//  Created by Karol Pilch on 07/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
	@IBOutlet weak var emailConstraint: NSLayoutConstraint!

	@IBOutlet weak var passwordConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var loginConstraint: NSLayoutConstraint!
	
	var animationEngine: AnimationEngine!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.animationEngine = AnimationEngine(constraints: [emailConstraint, passwordConstraint, loginConstraint])
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		// Only start animating after the view appears.
		animationEngine.animateOnScreen(delay: 0.5)
	}
}

