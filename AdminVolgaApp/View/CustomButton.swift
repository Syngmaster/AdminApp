//
//  CustomButton.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 28/01/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }

}
