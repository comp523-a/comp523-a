//
//  LevelTableViewController.swift
//  Code Quest
//
//  Created by OSX on 9/21/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

/// Renders level select screen
class LevelTableViewController: UITableViewController {
	
	///Array of level objects
    var levels = [Level]()

	
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDefaultLevels()
    }
	
	/// Contains data for built in levels and adds them to level array
    func loadDefaultLevels() {
        let data1 = [[2,2,2,2,2,2],
                     [2,1,1,1,1,2],
                     [2,2,2,2,2,2]]
		let level1 = Level(name: "Level 1", data: data1, startingLoc: (1, 1), goalLoc: (4, 1))
        let data2 = [[2,2,2],
                     [2,1,2],
                     [2,1,2],
                     [2,1,2],
                     [2,4,2],
                     [2,2,2]]
		let level2 = Level(name: "Level 2", data: data2, startingLoc: (1, 1), goalLoc: (1, 4))
        let data3 = [[2,2,2,2,2,2],
                     [2,1,1,1,4,2],
                     [2,1,1,1,1,2],
                     [2,1,1,1,1,2],
                     [2,2,2,2,2,2]]
		let level3 = Level(name: "Level 3", data: data3, startingLoc: (1, 3), goalLoc: (4, 1))

        levels += [level1, level2, level3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LevelTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LevelTableViewCell
        let level = levels[indexPath.row]
    

        cell.levelLabel.text = level.name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStage" {
            let LevelViewController = segue.destination as! ViewController
            if let selectedLevelCell = sender as? LevelTableViewCell {
                let indexPath = tableView.indexPath(for: selectedLevelCell)!
                let selectedLevel = levels[indexPath.row]
                LevelViewController.level = selectedLevel
            }
        }
    }
    

}
