//
//  Timer.swift
//  MindTeaser
//
//  Created by Karol Pilch on 24/01/2017.
//  Copyright © 2017 Karol Pilch. All rights reserved.
//

import UIKit

class CountdownTimer {
	
	// MARK: Class internals
	private var ticker: Timer? = nil
	private var timeStart: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
	
	private let tickInterval: CFTimeInterval = CFTimeInterval(0.05)	// 50ms
	private var now: CFAbsoluteTime {
		return CFAbsoluteTimeGetCurrent()
	}
	
	private func newTimer() -> Timer {
		return Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true, block: { (_ timer: Timer) in
			self.tick(timer)
		})
	}
	
	// ***** Publicly available getters that tell the state of the timer:
	private(set) var elapsedTime: CFTimeInterval = 0.0
	var remainingTime: CFTimeInterval {
		return max(duration - elapsedTime, 0.0)
	}
	private(set) var isRunning: Bool = false
	private(set) var isPaused: Bool = false
	private(set) var isFinished: Bool = false
	
	// Executes every tick of the internal timer.
	// Calculates the remaining time and stops the timer if needed.
	private func tick(_ timer: Timer) {
		if isRunning {
			elapsedTime = now - timeStart
			
			if let callback = everyTick {
				callback()
			}
			
			if elapsedTime >= duration {
				finished()
			}
		}
	}
	
	// Executed when timer completed.
	private func finished() {
		ticker?.invalidate()
		ticker = nil
		
		isRunning = false
		isPaused = false
		isFinished = true
		
		if let callback = completion {
			callback()
		}
	}
	
	// MARK: Configuration
	
	// The initial countdown time.
	let duration: CFTimeInterval
	
	// Default init with 1s interval.
	init () {
		duration = CFTimeInterval(1.0)
	}
	
	init(duration: CFTimeInterval, after completionBlock: (() -> ())? = nil) {
		self.duration = duration
		self.completion = completionBlock
	}
	
	// Callbacks
	var completion: (() -> ())? = nil
	var everyTick: (() -> ())? = nil
	
	// MARK: Control
	
	// Starts the countdown from wherever it last finished.
	func start() {
		if !isPaused {
			// Unless we were paused, reset the elapsed time.
			elapsedTime = 0.0
		}
		
		// Set the start time to continue the countdown from now.
		timeStart = now - elapsedTime
		
		// Start ticking
		ticker = newTimer()
		
		// Set state
		isRunning = true
		isPaused = false
		isFinished = false
	}
	
	// Stops the countdown at the current value.
	func pause() {
		ticker?.invalidate()
		ticker = nil
		isPaused = true
		isRunning = false
	}
	
	// Resets countdown to the initial value.
	func reset() {
		elapsedTime = 0.0
	}
	
	// Stops the countdown and resets it.
	func stop() {
		pause()
		isPaused = false
		reset()
	}
}
