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
	
	var animator = ConstraintAnimator()
	var cardIndex = ConstraintAnimator.ManagedConstraintIndex()
	
	override func viewWillAppear(_ animated: Bool) {
		currentCard = Bundle.main.loadNibNamed("Card", owner: self, options: nil)![0] as! Card
		
		
		// Center the card using constraints:
		self.view.addSubview(currentCard!)
		currentCard.translatesAutoresizingMaskIntoConstraints = false
		currentCard.widthAnchor.constraint(equalToConstant: currentCard.bounds.width)
		currentCard.heightAnchor.constraint(equalToConstant: currentCard.bounds.width)
		currentCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
		
		let cardCenter = currentCard.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
		cardCenter.isActive = true
		
		// ... and hide it
		cardIndex = animator.hide(constraints: [cardCenter])
	}
  override func viewDidLoad() {
		super.viewDidLoad()
		
		animator.animateHorizontallyOnScreen(constraintsAt: cardIndex, from: .Left, after: 0.2)
		// Do any additional setup after loading the view.
  }

}
