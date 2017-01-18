//
//  GameVC.swift
//  MindTeaser
//
//  Created by Karol Pilch on 15/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit
import pop

class GameVC: UIViewController {
	
	// MARK: UI elements
	@IBOutlet weak var noBtn: CustomButton!
	@IBOutlet weak var yesBtn: CustomButton!
	@IBOutlet weak var titleLabel: UILabel!
	
	var currentCard: Card!
	
	// MARK: View behaviour
	
	var isStarted: Bool = false
	
	func startGame() {
		noBtn.isHidden = false
		yesBtn.setTitle("Yes", for: .normal)
		titleLabel.text = "Is this image the same as the previous?"
	}
	
	func checkAnswer() {
		
	}
	
	@IBAction func yesPressed(_ sender: CustomButton) {
		if isStarted {
			checkAnswer()
		}
		else {
			startGame()
		}
	}
	// MARK: View setup
  override func viewDidLoad() {
		super.viewDidLoad()
		
		currentCard = Bundle.main.loadNibNamed("Card", owner: self, options: nil)![0] as! Card
		currentCard.center = AnimationEngine.screenCenterPosition
		
		self.view.addSubview(currentCard)

		// Do any additional setup after loading the view.
  }

}
