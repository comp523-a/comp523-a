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
	
	init(level : inout [[gameCell]]) {
		self.level = level
	}
	
	/**
	Handles a single command
	
	- parameter input: integer indicating selected command
	- parameter playerLoc: tuple indicating the coordinates of the player
	
	*/
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
		var sounds = [leftSound, rightSound, upSound, downSound]
		
		switch input {
			case 0:
				dx = -1
			case 1:
				dx = 1
			case 2:
				dy = -1
			case 3:
				dy = 1
			default:
				print("Out of range input to moveCmd: \(input)")
		}
		let newCoords = (playerLoc.0 + dx, playerLoc.1 + dy)
		if(setPlayerLoc(playerLoc: &playerLoc, newCoords: newCoords)) {
			playSound(sound: sounds[input])
		} else {
			playSound(sound: bumpSound)
		}
	}
	
	// Utility functions
	
	/**
	Updates the level tile grid to reflect a new player position, if the player
	is allowed to be there
	
	-parameter playerLoc: current player loc
	-parameter newCoords: coordinates to try to move the player to
	
	*/
	func setPlayerLoc(playerLoc: inout (Int, Int), newCoords: (Int, Int)) -> Bool {
		if let oldLoc = level[playerLoc.1][playerLoc.0] as? floorCell, let newLoc = level[newCoords.1][newCoords.0] as? floorCell {
			oldLoc.makeNotPlayer()
			playerLoc = newCoords
			newLoc.makePlayer()
			return true
		} else {
			return false
		}
	}
	
}
