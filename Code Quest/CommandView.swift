//
//  CommandViewController.swift
//  Code Quest
//
//  Created by OSX on 9/28/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
let num_command_buttons = 7

///View that contains command butotns
class CommandView: UIView {

	///Array of command buttons
	var commandButtons = [Input]()
	///The game controller that is this view's parent
	var gameControllerView : ViewController?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		for i in 0..<num_command_buttons {
			let command = Input(type: ButtonType(rawValue : i)!, frame: CGRect(x: 0+150*i, y: 0, width: 128, height: 128));
			//command.backgroundColor = UIColor.cyan
			
			//command.addTarget(self, action: #selector(CommandView.commandTapped(_:)), for: .Touchdown)
			command.addTarget(self, action: #selector(CommandView.commandTapped(commandButton:)), for: .touchDown)
			commandButtons += [command]
			self.addSubview(command)
		}
	}
	
	/*override func intrinsicContentSize() -> CGSize {
		return CGSize(width: 240, height:44)
	}*/
	
	func commandTapped(commandButton: Input) {
		let cmdIndex = commandButton.type
		print("Command pressed \(cmdIndex)")
		gameControllerView?.getButtonInput(type: commandButton.type)
		//print(self.parent?.title)
		
	}
	
}
