//
//  Input.swift
//  Code Quest
//
//  Created by OSX on 9/28/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///Buttons that render in the instruction pane
class Input: UIButton {
	
	///(To be) enum describing what type of command this button corresponds to 
	var type: Int
	
	
	init(type: Int, frame: CGRect) {
		self.type = type
		super.init(frame: frame)
		switch type {
		case 0:
			self.setImage(UIImage(named:"left.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Left"
		case 1:
			self.setImage(UIImage(named:"right.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Right"
		case 2:
			self.setImage(UIImage(named:"up.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Up"
		default:
			self.setImage(UIImage(named:"down.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Down"
		}
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
