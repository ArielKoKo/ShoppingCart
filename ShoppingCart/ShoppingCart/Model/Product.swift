//
//  Product.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/24.
//

import Foundation
import UIKit

class Product: Codable {
    
    var productID: String
    var productName: String
    var description: String
    var price: String
    var image: String
    var quantity: String? = "0"
    
    init(productID: String, productName: String, description: String, price: String, image: String ) {
        self.productID = UUID().uuidString
        self.productName = productName
        self.description = description
        self.price = price
        self.image = image
    }
    
    convenience init() {
        self.init(productID: "", productName: "", description: "", price: "", image: "")
    }
}

class Cart: Codable {
    var quantity: String? = "0"
}

class Order {
    var orderID: String
    var productID: String?
    var customerID: String
    var userName: String?
    var userPhone: String?
    var userAddress: String?
    var totalQuantity: String?
    var totalAmount: String?
    var orderList: [Product]?
    var orderDate: String
    
    init() {
        self.orderID = UUID().uuidString
        self.customerID = UUID().uuidString
        self.orderDate = time()
    }
    
}

class OrderForm: Codable {
    var orderID: String
    var totalAmount: String
    var totalQuantity: String
    var orderDate: String
    var custID: String
}

class CustomerInfo: Codable {
    var customerID: String
    var userName: String
    var userPhone: String
    var userAddress: String
}

func time () -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let timeString = dateFormatter.string(from: Date())
    return timeString
}

