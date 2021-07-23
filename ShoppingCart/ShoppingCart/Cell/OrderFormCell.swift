//
//  OrderFormCell.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/7/4.
//

import UIKit

class OrderFormCell: UITableViewCell {
    
    @IBOutlet weak var orderDateLabel: UILabel! {
        didSet {
            orderDateLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var orderPriceLabel: UILabel! {
        didSet {
            orderPriceLabel.numberOfLines = 0
        }
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
