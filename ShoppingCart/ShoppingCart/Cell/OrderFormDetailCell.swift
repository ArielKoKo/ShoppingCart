//
//  OrderFormDetailCell.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/7/4.
//

import UIKit

class OrderFormDetailCell: UITableViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var detailProductName: UILabel! {
        didSet {
            detailProductName.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var detailProductPrice: UILabel! {
        didSet {
            detailProductPrice.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var detailProductQuantity: UILabel! {
        didSet {
            detailProductQuantity.numberOfLines = 0
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
