//
//  CartFooterCell.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/13/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class CartFooterCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
