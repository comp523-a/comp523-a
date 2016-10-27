//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
import AVFoundation

/// Primary game controller. Contains most game state information
class ViewController: UIViewController, UICollectionViewDelegate {
	
	/// Child view that contains command butotns
    @IBOutlet var ButtonView: CommandView!
	
    /// Level data for this stage
    var level : Level? = nil
	/// Player's current location
	var playerLoc : (Int, Int) = (0,0)
	/// Goal location
	var goalLoc : (Int, Int) = (0,0)
	/// Array of gameCells representing the player's current location
	var tileArray : [[gameCell]] = [[]]
	/// Queue of current commands
	var commandQueue : [Int] = []
    /// List of queued command views corresponding to elements of commmandQueue
    var commandQueueViews : [UIView] = []
	/// Current location in commandQueue
	var currentStep : Int = 0
	/// Timer that controls player movement
    var tickTimer = Timer()
	/// Command handler object
	var cmdHandler: CommandHandler? = nil
    /// Boolean to determine whether to accept commands
    var takeInput: Bool = true
    
	/// Controls game logic
    override func viewDidLoad() {
        super.viewDidLoad()
        if let testGrid = (level?.data)! as [[Int]]? {
			playerLoc = level!.startingLoc
			goalLoc = level!.goalLoc
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
                        //case 4:
                        //    cell = goalCell()
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
			if let goal = tileArray[goalLoc.1][goalLoc.0] as? floorCell {
				goal.makeGoal()           //Draw goal on position cell
			}
        }
		
		self.cmdHandler = CommandHandler(level: &tileArray, playerLoc: &playerLoc, goalLoc: &goalLoc)
		
		ButtonView.gameControllerView = self
		
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	/**
	Gets button input from the Input controller
	
	- parameter type: (To be) enum specifying type of button

	*/
    
    // TODO: Rewrite this function as a switch over ButtonTypes
	func getButtonInput(type:ButtonType) {
        if (takeInput) {
            if (type.rawValue < 4) { // If command is to be added to queue
                let imageNames = ["left", "right", "up", "down"]
                let sounds = [leftSound, rightSound, upSound, downSound]
                let tempCell = UIImageView(image: UIImage(named:imageNames[type.rawValue] + ".png"))
                tempCell.frame = CGRect(x:70*commandQueue.count, y:512, width: 64, height:64)
                tempCell.isAccessibilityElement = true
                tempCell.accessibilityTraits = UIAccessibilityTraitImage
                tempCell.accessibilityLabel = imageNames[type.rawValue]
                self.view.addSubview(tempCell)
                commandQueue.append(type.rawValue)
                commandQueueViews.append(tempCell)
                playSound(sound: sounds[type.rawValue])
            } else { // Command is to be executed immediately
                if (type == ButtonType.ERASE1) {
                    commandQueueViews.popLast()?.removeFromSuperview()
                    commandQueue.popLast()
                } else if (type == ButtonType.ERASEALL) {
                    for view in commandQueueViews {
                        view.removeFromSuperview()
                    }
                    commandQueueViews.removeAll()
                    commandQueue.removeAll()
                }
            }
        }
	}
	
	/// Action for Play Button
    @IBAction func PlayButton(_ sender: UIButton) {
        if (takeInput) {
            // Don't take input while commands are running
            takeInput = false
            
            // Later, instead of accessing one of cmdHandler's helper methods,
            // simply send a reset command
            cmdHandler?.setPlayerLoc(newCoords: level!.startingLoc)
			cmdHandler?.resetGoal(coords: level!.goalLoc)
            
            currentStep = 0
            tickTimer = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector:#selector(ViewController.runCommands), userInfo:nil, repeats: true)
        }
    }
	
	/// Executes one step of the game loop
	func runCommands() {
		var won = false
		if currentStep < commandQueue.count {
			won = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!
		}
		currentStep += 1
		if currentStep >= commandQueue.count {
			tickTimer.invalidate()
            
            // All commands run, ready to take input again
            takeInput = true
			
			if (won) {
				let alert = UIAlertController(title: "You win!", message: "You took \(commandQueue.count) steps", preferredStyle: UIAlertControllerStyle.alert)
				alert.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.default, handler: nil))
				self.present(alert, animated: true, completion: nil)

			}
		}
		
	}
}

