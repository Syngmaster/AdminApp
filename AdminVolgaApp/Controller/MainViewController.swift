//
//  MainViewController.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 28/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

enum ButtonType: Int {
    case addItem   = 0
    case showItems = 1
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cat" {
            let dvc = segue.destination as! CategoryViewController
            let buttonTag = sender as! Int
            dvc.type = buttonTag
        }
    }


    
    @IBAction func itemAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "cat", sender: sender.tag)
    }
}

