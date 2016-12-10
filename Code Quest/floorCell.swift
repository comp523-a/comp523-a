//
//  floorCell.swift
//  Code Quest
//
//  Created by (You) Narukami on 9/20/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit


///Floor cells, which current can be empty or contain the player
class floorCell: gameCell {

	///Indicates whether or not the cell contains the player
	var isPlayer: Bool = false
	///Indicates whether or not the cell contains the goal
	var isGoal: Bool = false
	///Indicates whether or not the cell is a breakable wall
	var isWall: Bool
	
	init(isWall: Bool) {
		self.isWall = isWall
		if isPlayer {
			super.init(image: UIImage(named:"player.png"))
			self.accessibilityLabel = "Player"
		} else if(isWall) {
			super.init(image: UIImage(named:"wall.png"))
			self.accessibilityLabel = "Wall"
		} else {
			super.init(image: UIImage(named:"grid.png"))
			self.accessibilityLabel = "Floor"
		}
		
    }
	
	///Changes image and VoiceOver label to player
	func makePlayer() {
		isPlayer = true
		self.image = UIImage(named:"player.png")
		self.accessibilityLabel = "Player"
	}
	
	///Changes image and VoiceOver label to floor
	func makeNotPlayer() {
		isPlayer = false
		self.image = UIImage(named:"grid.png")
		self.accessibilityLabel = "Empty"
	}
	
	///Changes image and VoiceOver label to goal
	func makeGoal() {
		isGoal = true
		self.image = UIImage(named:"ship_grid.png")
		self.accessibilityLabel = "Goal"
	}
	
	func makeNotWall() {
		self.isWall = false
		self.image = UIImage(named:"grid.png")
		self.accessibilityLabel = "Empty"
	}
	
	func makeWall() {
		self.isWall = true
		self.image = UIImage(named:"wall.png")
		self.accessibilityLabel = "Wall"
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
