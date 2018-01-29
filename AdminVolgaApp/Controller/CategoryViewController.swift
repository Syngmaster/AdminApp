//
//  CategoryViewController.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 28/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var type:Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if type == 0 {
            return 3
        } else {
            return 4
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0: cell.textLabel?.text = "MEN"
        case 1: cell.textLabel?.text = "WOMEN"
        case 2: cell.textLabel?.text = "UNISEX"
        default: break
        }
        
        if type == 1 {
            if indexPath.row == 3 {
                cell.textLabel?.text = "SALE"
            }
//            if let saleCell = tableView.cellForRow(at: indexPath) {
//                if let saleCellIndex = tableView.indexPath(for: saleCell) {
//                    if saleCellIndex.row == 3 {
//                        saleCell.textLabel?.text = "SALE"
//                    }
//                }
//            }

            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
 


}
