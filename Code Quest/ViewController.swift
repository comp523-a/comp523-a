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
	/// Array of gameCells representing the player's current location
	var tileArray : [[gameCell]] = [[]]
	/// Queue of current commands
	var commandQueue : [Int] = []
	/// Current location in commandQueue
	var currentStep : Int = 0
	/// Timer that controls player movement
    var tickTimer = Timer()
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
    
	/// Controls game logic
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
	
	/**
	Sets the player to a location if its an empty cell, otherwise plays a noise
	
	- parameter newCoords: Desired location in (x,y)
	
	*/
	func setPlayerLocation(newCoords: (Int, Int)) {
		if let oldLoc = tileArray[playerLoc.1][playerLoc.0] as? floorCell, let newLoc = tileArray[newCoords.1][newCoords.0] as? floorCell {
			oldLoc.makeNotPlayer()
			playerLoc = newCoords
			newLoc.makePlayer()
		} else {
			playSound(sound:bumpSound)
		}
	}
	
	/**
	Plays a sound effect specified by a URL ()
	
	- parameter sound: Desired sound effect
	*/
	func playSound(sound: URL) {
		do {
			try audioPlayer = AVAudioPlayer(contentsOf: sound)
			audioPlayer.prepareToPlay()
			audioPlayer.play()
		} catch{
			print ("oops!")
		}
	}
	
	/// Tries to move the player one tile left
	func moveLeft() {
		playSound(sound: leftSound)
		setPlayerLocation(newCoords: (playerLoc.0 - 1, playerLoc.1))
	}
	
	/// Tries to move the player one tile right
	func moveRight() {
		playSound(sound: rightSound)
		setPlayerLocation(newCoords: (playerLoc.0 + 1, playerLoc.1))
	}
	
	/// Tries to move the player one tile up
	func moveUp() {
		playSound(sound: upSound)
		setPlayerLocation(newCoords: (playerLoc.0, playerLoc.1 - 1))
	}
	
	/// Tries to move the player one tile down
	func moveDown() {
		playSound(sound: downSound)
		setPlayerLocation(newCoords: (playerLoc.0, playerLoc.1 + 1))
	}
	
	/**
	Gets button input from the Input controller
	
	- parameter type: (To be) enum specifying type of button
	
	
	*/
	func getButtonInput(type:Int) {

		let imageNames = ["left", "right", "up", "down"]
		let sounds = [leftSound, rightSound, upSound, downSound]
		let tempCell = UIImageView(image: UIImage(named:imageNames[type] + ".png"))
		tempCell.frame = CGRect(x:70*commandQueue.count, y:512, width: 64, height:64)
		tempCell.isAccessibilityElement = true
		tempCell.accessibilityTraits = UIAccessibilityTraitImage
		tempCell.accessibilityLabel = imageNames[type]
		self.view.addSubview(tempCell)
		commandQueue.append(type)
		playSound(sound: sounds[type])
        
	}
	
	/// Action for Play Button
    @IBAction func PlayButton(_ sender: UIButton) {
        setPlayerLocation(newCoords: level!.startingLoc)
		currentStep = 0
		tickTimer = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector:#selector(ViewController.loopCommando), userInfo:nil, repeats: true)
		
    }
	
	/// Executes one step of the game loop
	func loopCommando() {

		if currentStep < commandQueue.count {
			switch commandQueue[currentStep] {
			case 0: moveLeft()
			case 1: moveRight()
			case 2: moveUp()
			case 3: moveDown()
			default: break
			}
		}
		currentStep += 1
		if currentStep >= commandQueue.count {

			tickTimer.invalidate()
		}
	}
}

