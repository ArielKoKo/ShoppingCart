//
//  ProductCell.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/24.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func updateProduct(cell: ProductCell)
}

class ProductCell: UITableViewCell {
    
    weak var delegate: ProductCellDelegate?
    
    @IBOutlet weak var nameText: UILabel! {
        didSet {
            nameText.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var descriptionText: UILabel! {
        didSet {
            descriptionText.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var priceText: UILabel! {
        didSet {
            priceText.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var productImageView: UIImageView!

    @IBOutlet weak var numberText: UILabel!
    
    @IBOutlet weak var numberTextField: UITextField! {
        didSet {
            numberTextField.text = "0"
        }
    }
    
    @IBOutlet weak var stepperButton: UIStepper! {
        didSet {
        stepperButton.value = 0
        stepperButton.minimumValue = 0
        stepperButton.maximumValue = 100
        stepperButton.stepValue = 1
        stepperButton.autorepeat = true
        stepperButton.isContinuous = true
        stepperButton.wraps = true
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
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        if numberTextField.text == "0" {
            stepperButton.value = 1
        }
        self.numberTextField.text = "\(Int(stepperButton.value))"
        self.delegate?.updateProduct(cell: self)
    }
    
    
}
