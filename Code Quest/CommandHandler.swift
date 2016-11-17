//
//  CommandHandler.swift
//  Code Quest
//
//  Created by Anthony Lawrence Vallario on 10/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CommandHandler {
	
	/// Cell-based representation of the level
	var level: [[gameCell]]
	/// Location of the Player in (x, y)
	var playerLoc: (Int, Int)
	/// Location of the goal in (x, y)
	var goalLoc: (Int, Int)
	/// Number of commands run
	var commandCount: Int = 0

	init(level : inout [[gameCell]], playerLoc : inout (Int, Int), goalLoc : inout (Int, Int)) {
		self.level = level
		self.playerLoc = playerLoc
		self.goalLoc = goalLoc
	}
	
	/**
	Handles a single command. Returns true if the player wins.
	
	- parameter input: integer indicating selected command
	- parameter playerLoc: tuple indicating the coordinates of the player
	
	*/
	func handleCmd(input: Int) -> (Bool, Bool){
		// Switch command input type, call appropriate functions
		// Current encoding:	0 - Left
		//						1 - Right
		//						2 - Up
		//						3 - Down
		
		if (input == 0 || input == 1 || input == 2 || input == 3) {
			return self.moveCmd(input: input)
		} else {
			print("Unrecognized command index: \(input)")
			return (false, false)
		}
	}
	
	// Specialized command handling functions
	
	/**
	Given a command, returns the coordinate that command would move the player to.
	
	- parameter input: integer indicating selected command
	
	*/
	func newCoordsFromCommand(input: Int) -> (Int, Int) {
		// Get player location offsets from move direction
		var dx = 0
		var dy = 0
		
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
		return (playerLoc.0 + dx, playerLoc.1 + dy)
	}
	
	/**
	Given a command, tries to move the player. Returns a tuple of bools indicating if the player succesfully moved, and if they won on that turn
	
	- parameter input: integer indicating selected command
	
	*/
	func moveCmd(input: Int) -> (Bool, Bool) {
		var sounds = [leftSound, rightSound, upSound, downSound]
		let newCoords = newCoordsFromCommand(input: input)
		let (moved, won) = setPlayerLoc(newCoords: newCoords)
		if(moved) {
			playSound(sound: sounds[input])
			if (won) {
				playSound(sound: cheerSound)
				///TODO: Move to view
							}
			
		} else {
			playSound(sound: bumpSound)
		}
		return (moved, won)
	}
	
	// Utility functions
	
	/**
	Updates the level tile grid to reflect a new player position, if the player
	is allowed to be there. Returns a tuple whose first value is true if the player successfully moved,
	and whose second value is true if the player moved to the goal.
	
	-parameter playerLoc: current player loc
	-parameter newCoords: coordinates to try to move the player to
	
	*/
	func setPlayerLoc(newCoords: (Int, Int)) -> (Bool, Bool) {
		
		if (newCoords.0 >= 0) && (newCoords.0 < level[0].count) && (newCoords.1 >= 0) && (newCoords.1 < level.count-1) {  //Check boundaries - Why does it only work if 1 subtracted from height?
			if let oldLoc = level[playerLoc.1][playerLoc.0] as? floorCell, let newLoc = level[newCoords.1][newCoords.0] as? floorCell {		//Check if space is floor
				oldLoc.makeNotPlayer()
				playerLoc = newCoords
				let isGoal = newLoc.isGoal
				newLoc.makePlayer()
				return (true, isGoal)
			} else {
				return (false, false)
			}
		}
		else {
			return (false, false)
		}
	}
	
	///For reset of level (e.g.pressing play) - restores goal image/label on goal cell
	func resetGoal(coords: (Int, Int)) -> Bool {
		if let loc = level[goalLoc.1][goalLoc.0] as? floorCell {
			loc.makeGoal()
			return true
		} else {
			return false
		}
	}
	
}
