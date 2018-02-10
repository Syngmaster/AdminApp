//
//  ItemModel.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 28/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class ItemModel: NSObject {
    
    var itemName: String!
    var itemPrice: String!
    var itemDescription: String!
    var isOnSale: Bool!
    
    var photoURLArray = [String]()
    var photoArray = [UIImage]()
    
    init(dict:NSDictionary) {
        itemName = dict.value(forKey: "itemName") as! String
        itemPrice = dict.value(forKey: "itemPrice") as! String
        itemDescription = dict.value(forKey: "description") as! String
        isOnSale = dict.value(forKey: "isOnSale") as! Bool
        
    }
    
    init(name:String!, price:Int!, description:String!, onSale: Bool!) {
        
        
    }

}
