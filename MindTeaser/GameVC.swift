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
import AVFoundation
import pop

class GameVC: UIViewController {
	
	// MARK: UI elements
	@IBOutlet weak var noBtn: CustomButton!
	@IBOutlet weak var yesBtn: CustomButton!
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var feedbackLabel: UILabel!
	@IBOutlet weak var feedbackLabelLeading: NSLayoutConstraint!
	var feedbackAnimatorIndex: ConstraintAnimator.ManagedConstraintIndex!
	
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
	
	// MARK: Answer handling
	enum Answer { case Yes; case No }
	
	var previousCardIndex: Int!
	var goodAnswersCount: Int = 0
	var badAnswersCount: Int = 0
	
	var feedbackAnimator = ConstraintAnimator()
	
	func popFeedback(correct: Bool) {
		feedbackLabel.text = correct ? "✅" : "❌"
		feedbackAnimator.animateHorizontallyOnScreen(constraintsAt: feedbackAnimatorIndex) {
			self.feedbackAnimator.animateHorizontallyOffScreen(constraintsAt: self.feedbackAnimatorIndex, to: .Left)
		}
	}
	
	
	func check(answer: Answer) {
		let correct = (previousCardIndex == currentCard.view.currentImageIndex) == (answer == .Yes)
		if correct {
			goodAnswersCount += 1
		} else {
			badAnswersCount += 1
		}
		
		handle(correct: correct)
		
		previousCardIndex = currentCard.view.currentImageIndex
	}
	
	
	func handle(correct: Bool) {
		popFeedback(correct: correct)
		if correct {
			playSound(forKey: "ding")
		}
		else {
			playSound(forKey: "bad")
		}
	}
	
	
	func showNextCard() {
		let oldCard = currentCard!
		
		// Animate current card off-screen:
		cardAnimator.animateHorizontallyOffScreen(constraintsAt: oldCard.animatorIndex!, to: .Left) {
			let _ = self.cardAnimator.removeConstraints(at: oldCard.animatorIndex!)
			oldCard.view.removeFromSuperview()
		}
		
		// Create a new card and animate it on screen!
		currentCard = createCard()
		currentCard.animatorIndex = cardAnimator.hide(constraints: [currentCard.center], on: .Right)
		currentCard.view.isHidden = false
		cardAnimator.animateHorizontallyOnScreen(constraintsAt: currentCard.animatorIndex!, from: .Right)
	}
	
	
	@IBAction func yesPressed(_ sender: CustomButton) {
		if isStarted {
			check(answer: .Yes)
			
		}
		else {
			startGame()
		}
		
		showNextCard()
	}
	
	
	@IBAction func noPressed(_ sender: CustomButton) {
		check(answer: .No)
		showNextCard()
	}
	
	
	@IBOutlet weak var timerView: TimerView!
	
	
	// MARK: View setup
	var cardAnimator = ConstraintAnimator()
	typealias ConstrainedCard = (view: Card, center: NSLayoutConstraint, animatorIndex: ConstraintAnimator.ManagedConstraintIndex?)
	
	
	// Sound library:
	var sounds = [String: AVAudioPlayer]()
	func playSound(forKey key: String) {
		if let player = sounds[key] {
			if player.isPlaying {
				player.stop()
			}
			player.currentTime = 0.0
			player.play()
		}
	}
	
	
	// Creates a new card and hides it immediately.
	func createCard() -> ConstrainedCard {
		let newCard = Bundle.main.loadNibNamed("Card", owner: self, options: nil)![0] as! Card
		newCard.isHidden = true
		view.insertSubview(newCard, belowSubview: feedbackLabel)
		
		newCard.translatesAutoresizingMaskIntoConstraints = false
		newCard.widthAnchor.constraint(equalToConstant: newCard.bounds.width).isActive = true
		newCard.heightAnchor.constraint(equalToConstant: newCard.bounds.width).isActive = true
		newCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
		
		let cardCenter = newCard.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
		cardCenter.isActive = true
		
		return (view: newCard, center: cardCenter, animatorIndex: nil)
	}
	
	
	override func viewDidLoad() {
		
		// Prepare animators:
		cardAnimator.defaultDelay = 0
		cardAnimator.springSpeed = 4
		cardAnimator.springBounciness = 4
		
		feedbackAnimator.defaultDelay = 0.0
		feedbackAnimator.springSpeed = 17
		feedbackAnimator.springBounciness = 13
		
		// Off-screen position for this constraint is a lot closer than default:
		feedbackAnimator.offScreenPositionLeft = -50.0
		
		feedbackAnimatorIndex = feedbackAnimator.hide(constraints: [feedbackLabelLeading])
		
		timerView.whenFinished = {
			print ("Timer is done!")
		}
		
		// Load the sounds
		if let player = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "ding", withExtension: "wav", subdirectory: nil)!) {
			player.prepareToPlay()
			sounds["ding"] = player
		}
		
		if let player = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "bad", withExtension: "wav", subdirectory: nil)!) {
			player.prepareToPlay()
			sounds["bad"] = player
		}
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		currentCard = createCard()
		previousCardIndex = currentCard.view.currentImageIndex
		currentCard.animatorIndex = cardAnimator.hide(constraints: [currentCard.center])
		currentCard.view.isHidden = false
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		cardAnimator.animateHorizontallyOnScreen(constraintsAt: currentCard.animatorIndex!)
	}
}
