//
//  SoundPlayer.swift
//  Code Quest
//
//  Created by Anthony Lawrence Vallario on 10/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import AVFoundation

/// Sound that plays when moving left
let leftSound = URL(fileURLWithPath: Bundle.main.path(forResource: "left", ofType:"wav")!);
/// Sound that plays when moving right
let rightSound = URL(fileURLWithPath: Bundle.main.path(forResource: "right", ofType:"wav")!);
/// Sound that plays when moving up
let upSound = URL(fileURLWithPath: Bundle.main.path(forResource: "up", ofType:"wav")!);
/// Sound that plays when moving down
let downSound = URL(fileURLWithPath: Bundle.main.path(forResource: "down", ofType:"wav")!);
/// Sound that plays when bumping into a wall
let bumpSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bump", ofType:"wav")!);
let failSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bumpo", ofType:"wav")!);
let cheerSound = URL(fileURLWithPath: Bundle.main.path(forResource: "cheer", ofType:"mp3")!);
/// Audio player for sound effects
var audioPlayer = AVAudioPlayer()

func playSound(sound: URL) {
	do {
		try audioPlayer = AVAudioPlayer(contentsOf: sound)
		audioPlayer.prepareToPlay()
		audioPlayer.play()
	} catch{
		print ("Failed to play sound: \(sound)")
	}
}
