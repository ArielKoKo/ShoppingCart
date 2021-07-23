//
//  OrderListViewController.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/30.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerQuantityLabel: UILabel!
    @IBOutlet weak var footerPriceLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderPhoneLabel: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    
    var orderProduct: [Product]!
    var totalOrderQuantity: Int = 0
    var totalOrderPrice: Int = 0
    var order = Order()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.order.orderList = self.orderProduct
        print("訂單編號: \(self.order.orderID)")
        
        self.tableView.dataSource = self
        // orderInfo
        let name = UserDefaults.standard.value(forKey: "userName")
        let phone = UserDefaults.standard.value(forKey: "userPhone")
        let address = UserDefaults.standard.value(forKey: "userAddress")
        
        self.orderNameLabel.text = "訂購人姓名: \(name!)"
        self.orderPhoneLabel.text = "訂購人電話: \(phone!)"
        self.orderAddress.text = "訂購人地址: \(address!)"
        self.footerQuantityLabel.text = "訂單總數量: \(self.totalOrderQuantity)"
        self.footerPriceLabel.text = "訂單總金額: $\(self.totalOrderPrice)"
        self.okButton.setTitle("確定", for: .normal)
        self.okButton.setTitleColor(.white, for: .normal)
        self.navigationItem.title = "訂單完成"
        navigationItem.setHidesBackButton(true, animated: false)
        
        self.order.userName = name as? String
        self.order.userPhone = phone as? String
        self.order.userAddress = address as? String
        self.order.totalQuantity = "\(self.totalOrderQuantity)"
        self.order.totalAmount = "\(self.totalOrderPrice)"

        // FooterBorder
        let topFooterBorder = CALayer()
        topFooterBorder.backgroundColor = UIColor.gray.cgColor
        let borderSize = 1.0
        topFooterBorder.frame = CGRect(x: 0, y: CGFloat(borderSize), width: self.footerView.bounds.width, height: CGFloat(borderSize))
        self.footerView.layer.addSublayer(topFooterBorder)
        
        
        if UserDefaults.standard.value(forKey: "userID") == nil {
            let userID = self.order.customerID
            UserDefaults.standard.string(forKey: "userID")
            UserDefaults.standard.set(userID, forKey: "userID")
        } else if self.order.customerID != UserDefaults.standard.value(forKey: "userID") as! String {
            self.order.customerID = UserDefaults.standard.value(forKey: "userID") as! String
        }
        
        
    }
    
    // MARK: - 按鍵動作
    @IBAction func okButtonBackToFirstPage(_ sender: UIButton) {

        self.navigationController?.popToRootViewController(animated: true)
        addToOrderForm()
        addToOrderLine()
        addToCustomer()
        NotificationCenter.default.post(name: .reset, object: nil, userInfo: nil)
        let userID = self.order.customerID
        UserDefaults.standard.set(userID, forKey: "userID")

    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let orderImage = UIImage(named: self.orderProduct[indexPath.row].image)
        let resize = orderImage?.resize(maxEdge: 1024)
        cell.orderImageView.image = resize
        cell.orderNameLabel.text = "商品名稱: \(self.orderProduct[indexPath.row].productName)"
        cell.orderPriceLabel.text = "售價: $ \(self.orderProduct[indexPath.row].price)"
        cell.orderQuantityLabel.text = "數量: \(self.orderProduct[indexPath.row].quantity!)"
        print(self.orderProduct[indexPath.row].productID)
        
        return cell
    }

    // MARK: - 上傳到MySQL
    func addToOrderForm() {
        
        if let url = URL(string: "http://b53168cf6a43.ngrok.io/shoppingcart/orderform_add.php") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let param = "orderID=\(self.order.orderID)&custID=\(self.order.customerID)&totalQuantity=\(self.order.totalQuantity ?? "")&totalAmount=\(self.order.totalAmount ?? "")&orderDate=\(self.order.orderDate)"
            print(param)
            //post的資料要放在http body,Data型式
            request.httpBody = param.data(using: .utf8)
            
            let session = URLSession.shared

            let task = session.dataTask(with: request) { data, response, error in
                if let e = error {
                    print("error \(e)")
                    return
                }

                guard let responseData = data else{
                    return
                }

                let content = String(data:responseData, encoding: .utf8)
                print(content!)
            }
            task.resume()
        }
    }
    
    func addToOrderLine() {
        if let url = URL(string: "http://b53168cf6a43.ngrok.io/shoppingcart/orderLine_add.php") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            for i in 0..<self.orderProduct.count {
                let indexPath = IndexPath(row: i, section: 0)
                let param = "orderIDOL=\(self.order.orderID)&productIDOL=\(self.orderProduct[indexPath.row].productID)&orderQuantity=\(self.orderProduct[indexPath.row].quantity!)"
                print(param)
                request.httpBody = param.data(using: .utf8)
                let session = URLSession.shared
                
                let task = session.dataTask(with: request) { data, response, error in
                    if let e = error {
                        print("error \(e)")
                        return
                    }
                    
                    guard let responseData = data else{
                        return
                    }
                    
                    let content = String(data:responseData, encoding: .utf8)
                    print(content!)
                }
                
                task.resume()
            }
        }
    }
    
    func addToCustomer() {
        if let url = URL(string: "http://b53168cf6a43.ngrok.io/shoppingcart/customer_add.php") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            print(self.order.customerID)
            
            let param = "customerID=\(self.order.customerID)&customerName=\(self.order.userName ?? "")&customerPhone=\(self.order.userPhone ?? "")&customerAddress=\(self.order.userAddress ?? "")&totalPayment=\(self.order.totalAmount ?? "")"
            
            request.httpBody = param.data(using: .utf8)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { data, response, error in
                if let e = error {
                    print("error \(e)")
                    return
                }
                
                guard let responseData = data else{
                    return
                }
                
                let content = String(data:responseData, encoding: .utf8)
                print(content!)
            }
            
            task.resume()
        }
    }
    
   
}
