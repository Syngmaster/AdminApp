//
//  AddItemViewCell.swift
//  AdminVolgaApp
//
//  Created by Syngmaster on 05/02/2018.
//  Copyright © 2018 Syngmaster. All rights reserved.
//

import UIKit

class AddItemViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    func configureCell(photos:[AnyObject] , row: Int) {
        if row == 0 {
            imageView.image = UIImage(named:"add_photo_img.png")
        } else {
            imageView.image = photos[row - 1] as? UIImage
        }
    }
    
}


