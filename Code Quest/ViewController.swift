//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    let testGrid = [[2,2,2,2,2,2],
                    [2,3,1,1,1,2],
                    [2,2,2,2,2,2]]

    override func viewDidLoad() {
        super.viewDidLoad()
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
                    default:
                        cell = floorCell()
                }
                cell.frame = CGRect(x: 100 + 64*x, y: 100 + 64*y, width: 64, height: 64)
                self.view.addSubview(cell)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}

