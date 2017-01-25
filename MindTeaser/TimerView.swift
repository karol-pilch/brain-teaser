//
//  TimerView.swift
//  MindTeaser
//
//  Created by Karol Pilch on 25/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

@IBDesignable
class TimerView: UIView {
	
	// MARK: Class internals
	var view: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		prepareFromXib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareFromXib()
	}
	
	func prepareFromXib() {
		// Make the first timer:
		newTimer()
		
		// Load the view:
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
		
		// Prepare the view:
		view.frame = bounds
		addSubview(view)
	}
	
	private var timer: CountdownTimer?
	private func newTimer() {
		timer = CountdownTimer(duration: duration)
		timer?.everyTick = {
			self.updateTime()
		}
	}
	
	private func updateTime(specific: CFTimeInterval? = nil) {
		let time = specific ?? timer?.remainingTime ?? 0.0
		timeLabel.text = String(format: "%3.2f", time)
	}

	// MARK: Timer handling
	@IBInspectable var duration: Double = 60.0 {
		didSet {
			newTimer()
			updateTime(specific: duration)
		}
	}
	
	var whenFinished: (() -> ())? {
		didSet {
			self.timer?.completion = whenFinished
		}
	}
	
	func start() {
		if timer == nil {
			newTimer()
		}
		timer?.start()
	}
	
	func stop() {
		timer?.stop()
	}
	
	func pause() {
		timer?.pause()
	}
	
	func reset() {
		timer?.reset()
	}
	
	// MARK: Elements
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var timeLabel: UILabel!
	
	// The title
	@IBInspectable var title: String? {
		get {
			return titleLabel.text
		}
		set {
			if let text = newValue {
				titleLabel.text = text + separator
			}
			else {
				titleLabel.text = newValue
			}
		}
	}
	
	// The string that separates the title from the time:
	@IBInspectable var separator: String = ":"
	
	
}
