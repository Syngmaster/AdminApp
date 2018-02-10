//
//  DictionaryExtension.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 08/02/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func += (lhs: inout Dictionary, rhs: Dictionary) {
        lhs.merge(rhs) { (_, new) in new }
    }
}
