//
//  CategoryViewController.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 28/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subcat" {
            let dvc = segue.destination as! SubcategoryViewController
            let selectedCell = sender as! UITableViewCell
            dvc.category = selectedCell.textLabel?.text
        }
    }

}

// MARK: - Table view data source

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0: cell.textLabel?.text = "MEN"
        case 1: cell.textLabel?.text = "WOMEN"
        case 2: cell.textLabel?.text = "UNISEX"
        case 3: cell.textLabel?.text = "SALE"
        default: break
        }

        return cell
    }
    
}
    //MARK: TableViewDelegate

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            self.performSegue(withIdentifier: "subcat", sender: selectedCell)
        }
        
    }
    
}
