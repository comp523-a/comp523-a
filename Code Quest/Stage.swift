//
//  Stage.swift
//  Code Quest
//
//  Created by OSX on 9/21/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class Level {
    var name: String
    var data: [[Int]]
    
    init(name: String, data: [[Int]]){
        self.name = name
        self.data = data
    }
    
    func getDimenions() -> (Int, Int) {
        let yd = data.count
        let xd = data[0].count
        return (xd, yd)
    }
}
