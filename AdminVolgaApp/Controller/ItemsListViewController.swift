//
//  ItemsListViewController.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 08/02/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class ItemsListViewController: UITableViewController {
    
    var navTitle:String!
    var subcategory:Subcategory!
    var arrayOfItems:[ItemModel]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadItemsFromDatabase()
    }
    
    func downloadItemsFromDatabase() {
        DataManager.sharedInstance.downloadItems(category: subcategory.parentCategory, subcategory: navTitle!) { (result) in
            
            print("result - \(result)")
            self.arrayOfItems = result as? [ItemModel]
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    @objc func addItem(_ sender:UIBarButtonItem) {
        
        performSegue(withIdentifier: "addItem", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let dvc = segue.destination as! AddItemViewController
            //let subcategory = sender as! Category
            dvc.subcategory = subcategory
        }
        
        if segue.identifier == "showItem" {
            let dvc = segue.destination as! AddItemViewController
            let item = sender as! ItemModel
            dvc.item = item
            dvc.subcategory = subcategory
        }
        
    }
    



    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arrayOfItems = arrayOfItems {
            return arrayOfItems.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item = arrayOfItems![indexPath.row]
        cell.textLabel?.text = item.itemName

        return cell
    }
}

// MARK: - Table view delegate

extension ItemsListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = arrayOfItems[indexPath.row]
        performSegue(withIdentifier: "showItem", sender: item)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = arrayOfItems[indexPath.row]
            
            let alertVC = UIAlertController(title: "Info", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                DataManager.sharedInstance.deleteItem(category: self.subcategory.parentCategory, subcategory: self.navTitle, item: item, completion: {
                    self.downloadItemsFromDatabase()
                })
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
        }

    }
    
}
