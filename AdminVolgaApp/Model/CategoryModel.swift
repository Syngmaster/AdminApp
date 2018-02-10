//
//  CategoryModel.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 29/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class Subcategory {
    
    var subcategoryTitle: String!
    var subcategoryPhoto: String!
    var parentCategory: String!
    
    required init(photo: String!, title: String!, parent: String!) {
        subcategoryTitle = title
        subcategoryPhoto = photo
        parentCategory = parent
    }
    
    
}
