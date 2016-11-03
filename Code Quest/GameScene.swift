//
//  GameScene.swift
//  Code Quest
//
//  Created by OSX on 11/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene {
	let player = SKSpriteNode(imageNamed: "pt")
	var playerPosition : (Int, Int) = (0,0)
	
	
	override func didMove(to view: SKView) {
		backgroundColor = SKColor.clear
		player.position = getPlayerCoordinates()
		addChild(player)
	}
	
	func getPlayerCoordinates() -> CGPoint {
		print(size)
		return CGPoint(x: 96 * playerPosition.0 + 50, y: Int(self.size.height) - (50 + 64 + 96 * playerPosition.1))
	}
	
	func movePlayer(newPos : (Int, Int)) {
		playerPosition = newPos
		var playerMove = SKAction.move(to: getPlayerCoordinates(), duration: 0.15)
		print(newPos)
		print(getPlayerCoordinates())
		player.run(playerMove)
		
	}
	
	func setPlayerPos(newPos: (Int, Int)) {
		playerPosition = newPos
		player.position = getPlayerCoordinates()
	}
}
