//
//  CommandHandler.swift
//  Code Quest
//
//  Created by Anthony Lawrence Vallario on 10/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import AVFoundation

class CommandHandler {
	
	/// Cell-based representation of the level
	var level: [[gameCell]]
	/// Sound that plays when moving left
	var leftSound = URL(fileURLWithPath: Bundle.main.path(forResource: "lefto", ofType:"wav")!);
	/// Sound that plays when moving right
	var rightSound = URL(fileURLWithPath: Bundle.main.path(forResource: "righto", ofType:"wav")!);
	/// Sound that plays when moving up
	var upSound = URL(fileURLWithPath: Bundle.main.path(forResource: "upo", ofType:"wav")!);
	/// Sound that plays when moving down
	var downSound = URL(fileURLWithPath: Bundle.main.path(forResource: "downo", ofType:"wav")!);
	/// Sound that plays when bumping into a wall
	var bumpSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bumpo", ofType:"wav")!);
	/// Audio player for sound effects
	var audioPlayer = AVAudioPlayer()
	
	init(level : inout [[gameCell]]) {
		self.level = level
	}
	
	func handleCmd(input: Int, playerLoc: inout(Int, Int)) {
		// Switch command input type, call appropriate functions
		// Current encoding:	0 - Left
		//						1 - Right
		//						2 - Up
		//						3 - Down
		
		if (input == 0 || input == 1 || input == 2 || input == 3) {
			self.moveCmd(input: input, playerLoc: &playerLoc)
		} else {
			print("Unrecognized command index: \(input)")
		}
	}
	
	// Specialized command handling functions
	
	func moveCmd(input: Int, playerLoc: inout (Int, Int)) {
		
		// Get player location offsets from move direction
		var dx = 0
		var dy = 0
		var sound = leftSound
		
		switch input {
			case 0:
				dx = -1
			case 1:
				sound = rightSound
				dx = 1
			case 2:
				sound = upSound
				dy = -1
			case 3:
				sound = downSound
				dy = 1
			default:
				print("Out of range input to moveCmd: \(input)")
		}
		let newCoords = (playerLoc.0 + dx, playerLoc.1 + dy)
		
		
		// Execute move
		if let oldLoc = level[playerLoc.1][playerLoc.0] as? floorCell, let newLoc = level[newCoords.1][newCoords.0] as? floorCell {
			oldLoc.makeNotPlayer()
			playerLoc = newCoords
			newLoc.makePlayer()
			playSound(sound: sound)
		} else {
			playSound(sound:bumpSound)
		}
	}
	
	// Utility functions
	
	func playSound(sound: URL) {
		do {
			try audioPlayer = AVAudioPlayer(contentsOf: sound)
			audioPlayer.prepareToPlay()
			audioPlayer.play()
		} catch{
			print ("oops!")
		}
	}
	
	
	
}
