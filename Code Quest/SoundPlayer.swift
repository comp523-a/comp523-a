//
//  SoundPlayer.swift
//  Code Quest
//
//  Created by Anthony Lawrence Vallario on 10/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import AVFoundation

enum SoundEffect {
	case UP
	case DOWN
	case LEFT
	case RIGHT
	case BUMP
}

class SoundPlayer {
	/// Sound that plays when moving left
	var leftSound = URL(fileURLWithPath: Bundle.main.path(forResource: "left", ofType:"wav")!);
	/// Sound that plays when moving right
	var rightSound = URL(fileURLWithPath: Bundle.main.path(forResource: "right", ofType:"wav")!);
	/// Sound that plays when moving up
	var upSound = URL(fileURLWithPath: Bundle.main.path(forResource: "up", ofType:"wav")!);
	/// Sound that plays when moving down
	var downSound = URL(fileURLWithPath: Bundle.main.path(forResource: "down", ofType:"wav")!);
	/// Sound that plays when bumping into a wall
	var bumpSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bump", ofType:"wav")!);
	/// Audio player for sound effects
	var audioPlayer = AVAudioPlayer()
	
	/**
	Plays indicated sound effect
	
	- parameter sound: enum member indicating the desired sound effect
	
	*/
	func playSound(sound: SoundEffect) {
		var url: URL
		
		switch sound {
		case SoundEffect.LEFT:
			url = leftSound
		case SoundEffect.RIGHT:
			url = rightSound
		case SoundEffect.UP:
			url = upSound
		case SoundEffect.DOWN:
			url = downSound
		case SoundEffect.BUMP:
			url = bumpSound
		}
		
		do {
			try audioPlayer = AVAudioPlayer(contentsOf: url)
			audioPlayer.prepareToPlay()
			audioPlayer.play()
		} catch{
			print ("Failed to play sound: \(sound)")
		}
	}
}
