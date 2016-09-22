//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    var level : Level? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let testGrid = (level?.data)! as [[Int]]? {
            for y in 0..<testGrid.count {
                for x in 0..<testGrid[y].count {
                    var cell:gameCell
                    switch testGrid[y][x] {
                        case 1:
                            cell = floorCell()
                        case 2:
                            cell = wallCell()
                        case 3:
                            cell = playerCell()
                        case 4:
                            cell = goalCell()
                        default:
                            cell = floorCell()
                    }
                    cell.frame = CGRect(x: 100 + 64*x, y: 100 + 64*y, width: 64, height: 64)
                    self.view.addSubview(cell)
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

