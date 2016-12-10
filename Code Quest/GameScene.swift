//
//  GameScene.swift
//  Code Quest
//
//  Created by OSX on 11/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import SpriteKit

///The SpriteKit overlay that handles player movement
class GameScene : SKScene {
	///The player sprite
	let player = SKSpriteNode(imageNamed: "pt")
	///The player position in level coordinates
	var playerPosition : (Int, Int) = (0,0)
	var boomFrames = [SKTexture]()
	
	override func didMove(to view: SKView) {
		backgroundColor = SKColor.clear
		player.position = getPlayerCoordinates()
		addChild(player)
		for i in 1...16 {
			boomFrames.append(SKTexture(imageNamed: "boom (\(i)).png"))
			print("boom (\(i)).png")
		}
	}
	
	///Returns the player's screen coordinates based on their level coordinates
	func getPlayerCoordinates() -> CGPoint {
		return mapToScreenCoordinates(newPos: playerPosition)
	}
	
	///Maps level coordinates to screen coordinates
	func mapToScreenCoordinates(newPos : (Int, Int)) -> CGPoint {
		return CGPoint(x: 96 * newPos.0 + 50, y: Int(self.size.height) - (50 + 64 + 96 * newPos.1))
	}
	
	///Updates the player's location in level coordinates
	func movePlayer(newPos : (Int, Int)) {
		playerPosition = newPos
		let playerMove = SKAction.move(to: getPlayerCoordinates(), duration: 0.15)
		print(newPos)
		print(getPlayerCoordinates())
		player.run(playerMove)
		
	}
	
	///Updates the player's level coordinates without animating
	func setPlayerPos(newPos: (Int, Int)) {
		playerPosition = newPos
		player.position = getPlayerCoordinates()
	}
	
	///Moves the player towards the specified level coordinates, playing the bonk animation instead. 
	func tryToMoveTo(newPos: (Int, Int)) {
		let oldPos = getPlayerCoordinates()
		let theNewPos = mapToScreenCoordinates(newPos: newPos)
		let moveVector =  CGVector(dx: theNewPos.x - oldPos.x, dy: theNewPos.y - oldPos.y)
		let moveVector1 = CGVector(dx: moveVector.dx * 0.3, dy: moveVector.dy*0.3)
		let moveVector2 = CGVector(dx: moveVector.dx * -0.3, dy: moveVector.dy*(-0.3))
		let move1 = SKAction.move(by: moveVector1, duration: 0.1)
		let move2 = SKAction.move(by: moveVector2, duration: 0.1)
		let moveSequence = SKAction.sequence([move1, move2])
		player.run(moveSequence)
		
		
	}
	
	func kaboom (pos: (Int, Int)) {
		print("kabooming!")
		print(boomFrames)
		let kaboomo = SKSpriteNode(imageNamed: "boom (1).png")
		addChild(kaboomo)
		kaboomo.position = mapToScreenCoordinates(newPos: pos)
		kaboomo.run(SKAction.animate(with: boomFrames, timePerFrame: 0.1))
	}
}
