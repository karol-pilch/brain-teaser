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
	
	var currentCard: ConstrainedCard!
	
	// MARK: View behaviour
	
	var isStarted: Bool = false
	
	func startGame() {
		noBtn.isHidden = false
		yesBtn.setTitle("Yes", for: .normal)
		titleLabel.text = "Is this image the same as the previous?"
	}
	
	func checkAnswer() {
		
	}
	
	// HERE: Doing it with one card only is too slow. Use two cards and animate on / off screen simultaneously.
	
	func showNextCard() {
		let oldCard = currentCard!
		
		// Animate current card off-screen:
		animator.animateHorizontallyOffScreen(constraintsAt: oldCard.animatorIndex!, to: .Left) {
			let _ = self.animator.removeConstraints(at: oldCard.animatorIndex!)
			oldCard.view.removeFromSuperview()
		}
		
		// Create a new card and animate it on screen!
		currentCard = createCard()
		currentCard.animatorIndex = animator.hide(constraints: [currentCard.center], on: .Right)
		currentCard.view.isHidden = false
		animator.animateHorizontallyOnScreen(constraintsAt: currentCard.animatorIndex!, from: .Right)
	}
	
	@IBAction func yesPressed(_ sender: CustomButton) {
		if isStarted {
			checkAnswer()
		}
		else {
			startGame()
		}
		
		showNextCard()
	}
	
	@IBAction func noPressed(_ sender: CustomButton) {
		checkAnswer()
		showNextCard()
	}
	
	// MARK: View setup
	var animator = ConstraintAnimator()
	typealias ConstrainedCard = (view: Card, center: NSLayoutConstraint, animatorIndex: ConstraintAnimator.ManagedConstraintIndex?)
	
	// Creates a new card and hides it immediately.
	func createCard() -> ConstrainedCard {
		let newCard = Bundle.main.loadNibNamed("Card", owner: self, options: nil)![0] as! Card
		newCard.isHidden = true
		self.view.addSubview(newCard)
		
		newCard.translatesAutoresizingMaskIntoConstraints = false
		newCard.widthAnchor.constraint(equalToConstant: newCard.bounds.width).isActive = true
		newCard.heightAnchor.constraint(equalToConstant: newCard.bounds.width).isActive = true
		newCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
		
		let cardCenter = newCard.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
		cardCenter.isActive = true
		
		return (view: newCard, center: cardCenter, animatorIndex: nil)
	}
	
	override func viewDidLoad() {
		animator.defaultDelay = 0
		animator.springSpeed = 4
		animator.springBounciness = 4
	}
	
	override func viewWillAppear(_ animated: Bool) {
		currentCard = createCard()
		currentCard.animatorIndex = animator.hide(constraints: [currentCard.center])
		currentCard.view.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		animator.animateHorizontallyOnScreen(constraintsAt: currentCard.animatorIndex!)
	}
}
