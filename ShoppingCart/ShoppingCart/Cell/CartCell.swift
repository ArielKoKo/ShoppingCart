//
//  CartCell.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/26.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func updateCart(cell: CartCell)
}

class CartCell: UITableViewCell {
    
    weak var delegate: CartCellDelegate?

    @IBOutlet weak var cartImageView: UIImageView!
    
    @IBOutlet weak var cartNameLabel: UILabel! {
        didSet {
            cartNameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var cartPriceLabel: UILabel! {
        didSet {
            cartPriceLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var cartQuantityTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func cartQuantityPlusButton(_ sender: UIButton) {
        var quantity = Int(cartQuantityTextField.text!)
        quantity = quantity! + 1
        cartQuantityTextField.text = "\(quantity!)"
        self.delegate?.updateCart(cell: self)

    }
    
    
    @IBAction func cartQuantityMinus(_ sender: UIButton) {
        var quantity = Int(cartQuantityTextField.text!)
        if quantity! <= 0 {
            quantity = 0
        } else {
        quantity = quantity! - 1
        }
        cartQuantityTextField.text = "\(quantity!)"
        self.delegate?.updateCart(cell: self)
    }
    
    
    
}
