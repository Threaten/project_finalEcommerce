//
//  ProductsCell.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/27/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class ProductsCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var price: String = ""
    var name: String = ""
    
}
