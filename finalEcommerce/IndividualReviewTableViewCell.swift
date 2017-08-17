//
//  IndividualReviewTableViewCell.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/4/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class IndividualReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
