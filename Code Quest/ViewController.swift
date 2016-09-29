//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var ButtonView: CommandView!
	
    
    var level : Level? = nil
	var playerLoc : (Int, Int) = (0,0)
	var tileArray : [[gameCell]] = [[]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let testGrid = (level?.data)! as [[Int]]? {
			playerLoc = level!.startingLoc
            for y in 0..<testGrid.count {
				tileArray.append([])
                for x in 0..<testGrid[y].count {
                    var cell:gameCell
                    switch testGrid[y][x] {      //Instantiate gameCells based on input array
                        case 1:
							cell = floorCell()
                        case 2:
                            cell = wallCell()
                        case 3:
							cell = floorCell()
                        case 4:
                            cell = goalCell()
                        default:
							cell = floorCell()
                    }
                    cell.frame = CGRect(x: 100 + 64*x, y: 100 + 64*y, width: 64, height: 64)
                    self.view.addSubview(cell)
					self.tileArray[y].append(cell)  //Store gameCells in array for accessing
                }
            }
			if let player = tileArray[playerLoc.1][playerLoc.0] as? floorCell {
				player.makePlayer()       //Draw player on starting position cell
			}
        }
		
		ButtonView.gameControllerView = self
		
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setPlayerLocation(newCoords: (Int, Int)) {     //Changes player location coordinates and draws player on floor cell
		if let oldLoc = tileArray[playerLoc.1][playerLoc.0] as? floorCell, let newLoc = tileArray[newCoords.1][newCoords.0] as? floorCell {
			oldLoc.makeNotPlayer()
			playerLoc = newCoords
			newLoc.makePlayer()
		}
	}
	
	func moveLeft() {
		setPlayerLocation(newCoords: (playerLoc.0 - 1, playerLoc.1))
	}
	
	func moveRight() {
		setPlayerLocation(newCoords: (playerLoc.0 + 1, playerLoc.1))
	}
	
	func moveUp() {
		setPlayerLocation(newCoords: (playerLoc.0, playerLoc.1 - 1))
	}
	
	func moveDown() {
		setPlayerLocation(newCoords: (playerLoc.0, playerLoc.1 + 1))
	}
	
	func getButtonInput(type:Int) {
		switch type {
			case 0: moveLeft()
			case 1: moveRight()
			case 2: moveUp()
			case 3: moveDown()
			default: break
		}
	}

}

