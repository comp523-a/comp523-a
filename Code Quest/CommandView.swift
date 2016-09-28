//
//  CommandViewController.swift
//  Code Quest
//
//  Created by OSX on 9/28/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class CommandView: UIView {

	var commandButtons = [UIButton]()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		for i in 0..<4 {
			let command = UIButton(frame: CGRect(x: 0+50*i, y: 0, width: 44, height: 44));
			command.backgroundColor = UIColor.cyan
			
			//command.addTarget(self, action: #selector(CommandView.commandTapped(_:)), for: .Touchdown)
			command.addTarget(self, action: #selector(CommandView.commandTapped(commandButton:)), for: .touchDown)
			commandButtons += [command]
			addSubview(command)
		}
	}
	
	/*override func intrinsicContentSize() -> CGSize {
		return CGSize(width: 240, height:44)
	}*/
	
	func commandTapped(commandButton: UIButton) {
		var cmdIndex : Int?
		cmdIndex = commandButtons.index(of: commandButton)
		print("Command pressed \(cmdIndex)")
	}
	
}
