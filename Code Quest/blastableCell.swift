//
//  blastableCell.swift
//  Code Quest
//
//  Created by Hamid Ali on 12/5/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///A wall cell, which the player cannot cross
class blastableCell: gameCell {
	
	init() {
		super.init(image: UIImage(named:"wall.png"))
		self.accessibilityLabel = "Blastable Cell"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
