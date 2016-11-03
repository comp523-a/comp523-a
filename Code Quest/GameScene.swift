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
		return mapToScreenCoordinates(newPos: playerPosition)
	}
	
	func mapToScreenCoordinates(newPos : (Int, Int)) -> CGPoint {
		return CGPoint(x: 96 * newPos.0 + 50, y: Int(self.size.height) - (50 + 64 + 96 * newPos.1))
	}
	
	func movePlayer(newPos : (Int, Int)) {
		playerPosition = newPos
		let playerMove = SKAction.move(to: getPlayerCoordinates(), duration: 0.15)
		print(newPos)
		print(getPlayerCoordinates())
		player.run(playerMove)
		
	}
	
	func setPlayerPos(newPos: (Int, Int)) {
		playerPosition = newPos
		player.position = getPlayerCoordinates()
	}
	
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
}
