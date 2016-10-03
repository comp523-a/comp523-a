//
//  Stage.swift
//  Code Quest
//
//  Created by OSX on 9/21/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///Contains initialization data for a level
class Level {
	
	///Level's name
    var name: String
	///Array of (to be) enums specifying level data, accessed `data[y][x]`
    var data: [[Int]]
	///The player's starting location, `(x,y)`
	var startingLoc : (Int, Int)
	
	init(name: String, data: [[Int]], startingLoc: (Int, Int)){
        self.name = name
        self.data = data
		self.startingLoc = startingLoc
    }
	
	/**
	Returns the dimensions of the player grid
	
	-returns: dimensions of the grid as `(x,y)`
	*/
    func getDimenions() -> (Int, Int) {
        let yd = data.count
        let xd = data[0].count
        return (xd, yd)
    }
}
