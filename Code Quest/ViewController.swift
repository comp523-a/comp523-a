//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...6 {
            for j in 0...4 {
            var cell1 = gameCell(image: UIImage(named:"grid.png"))
            cell1.frame = CGRect(x: 100 + 64*i, y: 100 + 64*j, width: 64, height: 64)
            self.view.addSubview(cell1)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}

