//
//  Order.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/26.
//

import Foundation

class Order {
    var productName: String
    var description: String
    var price: String
    var image: String
    var number: String
    
    init(productName: String, description: String, price: String, image: String, number: String ) {
        self.productName = productName
        self.description = description
        self.price = price
        self.image = image
        self.number = number
    }
    
    convenience init() {
        self.init(productName: "", description: "", price: "", image: "", number: "")
    }
}
