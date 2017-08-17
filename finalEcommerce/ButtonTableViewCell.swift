//
//  ButtonTableViewCell.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/4/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import GMStepper

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBAction func addToCartButton_Pressed(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
