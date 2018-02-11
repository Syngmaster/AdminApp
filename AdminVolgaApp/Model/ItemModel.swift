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
    var itemPrice: Int!
    var itemDescription: String!
    var isOnSale: Bool!
    
    var photoURLArray = [String]()
    var photoArray = [UIImage]()
    
    init(dict:NSDictionary) {
        itemName = dict.value(forKey: "itemName") as! String
        itemPrice = dict.value(forKey: "price") as! Int
        itemDescription = dict.value(forKey: "description") as! String
        isOnSale = dict.value(forKey: "isOnSale") as! Bool
        
        let photoDict = dict.value(forKey: "photos") as! NSDictionary
        photoURLArray = photoDict.allValues as! [String]
        
    }
    
    init(name:String!, price:Int!, description:String!, onSale: Bool!) {
        itemName = name
        itemPrice = price
        itemDescription = description
        isOnSale = onSale
        
    }

}
