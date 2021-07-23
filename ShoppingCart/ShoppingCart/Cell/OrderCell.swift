//
//  OrderCell.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/30.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var orderImageView: UIImageView!
    
    @IBOutlet weak var orderNameLabel: UILabel! {
        didSet {
            orderNameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var orderPriceLabel: UILabel! {
        didSet {
            orderPriceLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var orderQuantityLabel: UILabel! {
        didSet {
            orderQuantityLabel.numberOfLines = 0
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
