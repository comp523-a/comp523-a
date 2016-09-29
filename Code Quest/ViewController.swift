//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var ButtonView: CommandView!
	
    
    var level : Level? = nil
	var playerLoc : (Int, Int) = (0,0)
	var tileArray : [[gameCell]] = [[]]
	var commandQueue : [Int] = []
	var currentStep : Int = 0
    var tickTimer = Timer()
	var leftSound = URL(fileURLWithPath: Bundle.main.path(forResource: "lefto", ofType:"wav")!);
	var rightSound = URL(fileURLWithPath: Bundle.main.path(forResource: "righto", ofType:"wav")!);
	var upSound = URL(fileURLWithPath: Bundle.main.path(forResource: "upo", ofType:"wav")!);
	var downSound = URL(fileURLWithPath: Bundle.main.path(forResource: "downo", ofType:"wav")!);
	var bumpSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bumpo", ofType:"wav")!);
	var audioPlayer = AVAudioPlayer()
    
	
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
		} else {
			playSound(sound:bumpSound)
		}
	}
	
	func playSound(sound: URL) {
		do {
			try audioPlayer = AVAudioPlayer(contentsOf: sound)
			audioPlayer.prepareToPlay()
			audioPlayer.play()
		} catch{
			print ("oops!")
	}
	}
	
	func moveLeft() {
		playSound(sound: leftSound)
		setPlayerLocation(newCoords: (playerLoc.0 - 1, playerLoc.1))
	}
	
	func moveRight() {
		playSound(sound: rightSound)
		setPlayerLocation(newCoords: (playerLoc.0 + 1, playerLoc.1))
	}
	
	func moveUp() {
		playSound(sound: upSound)
		setPlayerLocation(newCoords: (playerLoc.0, playerLoc.1 - 1))
	}
	
	func moveDown() {
		playSound(sound: downSound)
		setPlayerLocation(newCoords: (playerLoc.0, playerLoc.1 + 1))
	}
	
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
	

    @IBAction func PlayButton(_ sender: UIButton) {
        setPlayerLocation(newCoords: level!.startingLoc)
		currentStep = 0
		tickTimer = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector:#selector(ViewController.loopCommando), userInfo:nil, repeats: true)
		
    }
	
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

