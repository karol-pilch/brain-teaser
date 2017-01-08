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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
	}
}

