//
//  SubcategoryViewController.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 28/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class SubcategoryViewController: UITableViewController {
    
    var category:String!
    var arrayOfSubcategories = [Subcategory]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSubcategory(_:)))
        navigationItem.rightBarButtonItem = addButton
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataManager.sharedInstance.downloadSubCategories(category: category) { (result) in
            
            guard result as? [Subcategory] != nil else {
                self.raiseAlert()
                return
            }
            self.arrayOfSubcategories = result as! [Subcategory]
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }

    }
    
    @objc func addSubcategory(_ sender:UIBarButtonItem) {
        
        performSegue(withIdentifier: "addsubcat", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addsubcat" {
            let dvc = segue.destination as! AddSubcategoryViewController
            dvc.category = category
        }
        
        if segue.identifier == "itemsList" {
            let dvc = segue.destination as! ItemsListViewController
            let category = sender as! Subcategory
            dvc.navTitle = category.subcategoryTitle
            dvc.subcategory = category
        }
    }
    
    func raiseAlert() {
        let alertVC = UIAlertController(title: "Warning", message: "No internet connection!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}


// MARK: - Table view delegate

extension SubcategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = arrayOfSubcategories[indexPath.row]
        performSegue(withIdentifier: "itemsList", sender: category)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subcategory = arrayOfSubcategories[indexPath.row]
            
            let alertVC = UIAlertController(title: "Info", message: "Are you sure you want to delete this subcategory?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                
                DataManager.sharedInstance.deleteSubcategory(subcategory: subcategory, completion: { (result) in
                    if result {
                        self.showAlert(title: "Success", message: "Category deleted")
                    } else {
                        self.showAlert(title: "Error", message: "Please delete all items first")
                    }
                })
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)

        }
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)

    }
    
}
// MARK: - Table view data source

extension SubcategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSubcategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let category = arrayOfSubcategories[indexPath.row]
        cell.textLabel?.text = category.subcategoryTitle
        
        return cell
    }
}
