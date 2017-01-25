//
//  GameVC.swift
//  MindTeaser
//
//  Created by Karol Pilch on 15/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

/*

Exercise Requirements
=====================

* Create a timer 
  - that counts down from 1:00 to 0:00
  - that has a UILabel
  - that shows the clock counting down every second
* When the timer ends you will show UI that shows how many correct 
  and how many incorrect choices you made (this can be textual or 
  graphical UI)
* Every time you tap the correct answer a green check mark appears 
  overlaying the bottom right corner of the card for a brief 
  moment (you must find the graphical asset for this)
* Every time you tap the wrong answer a red x appears overlaying 
  the bottom right corner of the card for a brief moment (you must 
  find the graphical asset for this)
* When the timer ends there will be a replay button that restarts 
  the game

My plan
=======

* Make a timer class:
  - start / stop / reset
  - completion and update blocks
  - length of time
* Handle answers and count them
* Results: A new view
* Reset game function(s) in GameVC.

*/

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
		
		isStarted = true
		
		timerView.start()
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
	
	@IBOutlet weak var timerView: TimerView!
	
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
		
		timerView.whenFinished = {
			print ("Timer is done!")
		}
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
