//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

let imageNames = ["left", "right", "up", "down"]
let commandSounds = [leftSound, rightSound, upSound, downSound]

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
	/// The SpriteKit layer
	var scene : GameScene? = nil
	/// The parent level table view controller
	var parentLevelTableViewController : LevelTableViewController? = nil
	var won : Bool = false
	
	let music: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "song", ofType:"wav")!);
	var musicPlayer = AVAudioPlayer()
	let drum = URL(fileURLWithPath: Bundle.main.path(forResource: "drum", ofType:"wav")!);
	var drumPlayer = AVAudioPlayer()
	

    
	/// Controls game logic
    override func viewDidLoad() {
        super.viewDidLoad()
		do {
			try musicPlayer = AVAudioPlayer(contentsOf: music)
			try drumPlayer = AVAudioPlayer(contentsOf: drum)
			musicPlayer.numberOfLoops = -1
			drumPlayer.numberOfLoops = -1
			musicPlayer.volume = 0.6
			drumPlayer.volume = 0
			let sdelay : TimeInterval = 0.1
			let now = musicPlayer.deviceCurrentTime
			musicPlayer.play(atTime: now+sdelay)
			drumPlayer.play(atTime: now+sdelay)
		} catch {
			print ("music failed")
		}
		
		
		let touchOnResetRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.tapReset (_:)))
		self.view.addGestureRecognizer(touchOnResetRecognizer)
		
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
                    cell.frame = CGRect(x: 96*x, y: 64+96*y, width: 96, height: 96)
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
		
		if let tutorialString = (level?.tutorialText)! as String? {
			//let alert = UIAlertController(title: level?.name, message: tutorialString, preferredStyle: UIAlertControllerStyle.alert)
			//alert.addAction(UIAlertAction(title: "Start level", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.drumPlayer.volume = 1}))
			//self.present(alert, animated: true, completion: nil)
			let tText = LevelTutorialViewController()
			tText.tutorialText = tutorialString
			tText.modalPresentationStyle = .formSheet
			tText.modalTransitionStyle = .coverVertical
			tText.myParent = self
			if let background = (level?.background) as String? {
				tText.background = background
			}
			self.present(tText, animated: true, completion: {
				//self.drumPlayer.volume = 1
			})
			//self.showDetailViewController(tText, sender: self)
			
		}
		
		self.cmdHandler = CommandHandler(level: &tileArray, playerLoc: &playerLoc, goalLoc: &goalLoc)
		
		ButtonView.gameControllerView = self
		let skView = SKView(frame: view.bounds)
		skView.isUserInteractionEnabled = false
		skView.allowsTransparency = true
		self.view.addSubview(skView)
		self.scene = GameScene(size: view.bounds.size)
		scene?.playerPosition = playerLoc
		skView.presentScene(scene)
		
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tapReset(_ sender: UITapGestureRecognizer) {
		if (takeInput) {
			resetLevelState()
		}
	}
	
	func resetLevelState() {
		scene?.setPlayerPos(newPos: level!.startingLoc)
		cmdHandler?.setPlayerLoc(newCoords: level!.startingLoc)
		cmdHandler?.resetGoal(coords: level!.goalLoc)
	}

	/**
	Gets button input from the Input controller
	
	- parameter type: (To be) enum specifying type of button

	**/
    
    // TODO: Rewrite this function as a switch over ButtonTypes
	func getButtonInput(type:ButtonType) {
        if (takeInput) {
			resetLevelState()
            if (type.rawValue < 4 && commandQueue.count < 140) { // If command is to be added to queue and queue is not full
                let tempCell = UIImageView(image: UIImage(named:imageNames[type.rawValue] + ".png"))
                tempCell.frame = CGRect(x:70*commandQueue.count, y:512+84, width: 64, height:64)
                tempCell.isAccessibilityElement = true
                tempCell.accessibilityTraits = UIAccessibilityTraitImage
                tempCell.accessibilityLabel = imageNames[type.rawValue]
                self.view.addSubview(tempCell)
                commandQueue.append(type.rawValue)
                commandQueueViews.append(tempCell)
                playSound(sound: commandSounds[type.rawValue])
			} else if(type.rawValue < 4 && commandQueue.count >= 14) {
				
				playSound(sound: failSound);
				let delayTime = DispatchTime.now() + .milliseconds(300)
				DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
					UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Command queue full");
				})
				
				
				
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
				} else if (type == ButtonType.QUEUESOUND) {
					takeInput = false
					currentStep = 0
					tickTimer = Timer.scheduledTimer(timeInterval: 0.5, target:self,
						selector:#selector(ViewController.runQueueSounds),
						userInfo:nil, repeats: true)
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
			resetLevelState()
            
            currentStep = 0
			won = false
            tickTimer = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector:#selector(ViewController.runCommands), userInfo:nil, repeats: true)
        }
    }
	
	/// Executes one step of the game loop
	func runCommands() {
		musicPlayer.volume = 0.1
		
		var moved = false
		if (currentStep != 0) {
			commandQueueViews[currentStep-1].frame.origin.y += 10
		}
		if currentStep < commandQueue.count {
			if (currentStep < (commandQueue.count - 1) ) {
				commandQueueViews[currentStep].frame.origin.y -= 10
			}
			var maybewon: Bool
			(moved, maybewon) = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!
			won = won || maybewon
			if (moved) {
				scene?.movePlayer(newPos: (cmdHandler?.playerLoc)!)
			} else {
				scene?.tryToMoveTo(newPos: (cmdHandler?.newCoordsFromCommand(input: commandQueue[currentStep]))!)
			}
		}
		currentStep += 1
		if currentStep >= commandQueue.count {
			tickTimer.invalidate()
            
            // All commands run, ready to take input again
            takeInput = true
			
			if (won) {
				musicPlayer.volume = 1
				playSound(sound: cheerSound)
				let alert = UIAlertController(title: "You win!", message: "You took \(commandQueue.count) steps", preferredStyle: UIAlertControllerStyle.alert)
				alert.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.musicPlayer.volume = 0.6}))
				self.present(alert, animated: true, completion: nil)
				if !level!.cleared {
					level!.cleared = true
					level!.highscore = commandQueue.count
				} else if commandQueue.count < level!.highscore {
					level!.highscore = commandQueue.count
				}
				if let selectedIndexPath = parentLevelTableViewController?.tableView.indexPathForSelectedRow{
					parentLevelTableViewController?.levels[selectedIndexPath.row] = level!
					parentLevelTableViewController?.saveLevels()
					parentLevelTableViewController?.tableView.reloadRows(at: [selectedIndexPath], with:.none)
				}
			} else {
				musicPlayer.volume = 0.6
			}
		}
		
		
	}
	
	override func viewWillDisappear(_ animated : Bool) {
		super.viewWillDisappear(animated)
		musicPlayer.stop()
		drumPlayer.stop()
	}
	
	// Plays the sound associated with the command in commandQueue[currentStep]
	// Note that commands and queue sounds will never be running at the same time, so it
	// should be safe to reuse tickTimer and currentStep here
	func runQueueSounds() {
		if (currentStep < commandQueue.count) {
			playSound(sound: commandSounds[commandQueue[currentStep]])
			currentStep += 1
		} else {
			tickTimer.invalidate()
			takeInput = true
		}
	}
}

