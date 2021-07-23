//
//  OrderFormDetailViewController.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/7/4.
//

import UIKit

class OrderFormDetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderPhoneLabel: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    var orderDetail : OrderForm!
    var detailProducts: [Product] = []
    var detailQuantity: [Cart] = []
    var customerInfo: [CustomerInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderNameLabel.text = "訂購人姓名:"
        self.orderPhoneLabel.text = "訂購人電話:"
        self.orderAddress.text = "訂購人地址:"
        
        DispatchQueue.global().async {
            self.queryCustomerFromPHP()
            self.queryFromPHP()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.orderNameLabel.text = "訂購人姓名: \(self.customerInfo[0].userName)"
                self.orderPhoneLabel.text = "訂購人電話: \(self.customerInfo[0].userPhone)"
                self.orderAddress.text = "訂購人地址: \(self.customerInfo[0].userAddress)"
            }
        }
        
        self.totalQuantityLabel.text = "訂單總數量: \(self.orderDetail.totalQuantity)"
        self.totalPriceLabel.text = "訂單總金額: $\(self.orderDetail.totalAmount)"
        self.tableView.dataSource = self
        
        // FooterBorder
        let topFooterBorder = CALayer()
        topFooterBorder.backgroundColor = UIColor.gray.cgColor
        let borderSize = 1.0
        topFooterBorder.frame = CGRect(x: 0, y: CGFloat(borderSize), width: self.footerView.bounds.width, height: CGFloat(borderSize))
        self.footerView.layer.addSublayer(topFooterBorder)

    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderFormDetailCell", for: indexPath) as! OrderFormDetailCell
        let orderImage = UIImage(named: self.detailProducts[indexPath.row].image)
        let resize = orderImage?.resize(maxEdge: 1024)
        cell.detailImageView.image = resize
        cell.detailProductName.text = "商品名稱: \(self.detailProducts[indexPath.row].productName)"
        cell.detailProductPrice.text = "售價: $ \(self.detailProducts[indexPath.row].price)"
        cell.detailProductQuantity.text = "數量: \(self.detailProducts[indexPath.row].quantity!)"

        return cell
    }
    
    // MARK: - 從MySQL下載訂單商品資訊
    // 下載訂單資料
    func queryFromPHP() {
        
        if let url = URL(string: "http://b53168cf6a43.ngrok.io/shoppingcart/orderProduct_update.php") {
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            let param = "orderID=\(self.orderDetail.orderID)"
            request.httpBody = param.data(using: .utf8)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let e = error {
                    print("error \(e)")
                    return
                }
                guard let responseData = data else {
                    return
                }
                do {
                    let content = String(data: responseData, encoding: .utf8)
                    print(content!)
                    
                    let decorder = JSONDecoder()
                    self.detailProducts = try decorder.decode([Product].self, from: responseData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error \(error)")
                }
            }
            task.resume()
        }
        
    }
    
    // 下載客戶資料
    func queryCustomerFromPHP() {
        
        if let url = URL(string: "http://b53168cf6a43.ngrok.io/shoppingcart/customer_update_json.php") {
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            let param = "custID=\(self.orderDetail.custID)"
            request.httpBody = param.data(using: .utf8)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let e = error {
                    print("error \(e)")
                    return
                }
                guard let responseData = data else {
                    return
                }
                do {
                    let content = String(data: responseData, encoding: .utf8)
                    print(content!)
                    
                    let decorder = JSONDecoder()
                    self.customerInfo = try decorder.decode([CustomerInfo].self, from: responseData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error \(error)")
                }
            }
            task.resume()
        }
    }
    
}

