//
//  ViewController.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/23.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDataSource, ProductCellDelegate, CartListViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var signBarButton: UIBarButtonItem!
    
    var products: [Product] = []
    var cartList : [Product] = []
    var cart :[Cart] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        NotificationCenter.default.addObserver(self, selector: #selector(resetAll(notification:)), name: .reset, object: nil)
    }
    
    @objc func resetAll(notification: Notification) {
        self.tabBarController?.tabBar.isHidden = false
        for i in 0..<self.products.count {
            let indexPath = IndexPath(row: i, section: 0)
            self.products[indexPath.row].quantity = "0"
            cart[indexPath.row].quantity = "0"
        }
        cartList = []
    }
    
    deinit {
        // 在被記憶體清除前,移除通知訂閱
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.navigationItem.title = "一極棒炒飯"
        self.checkButton.isEnabled = false
        self.signBarButton.title = "ChangeLog"
        
        self.addToCartButton.setTitle("加入購物車", for: .normal)
        self.addToCartButton.setTitleColor(.white, for: .normal)
        self.addToCartButton.titleLabel?.font = UIFont(name: "System", size: 20)
        self.addToCartButton.backgroundColor = .systemGray2
        
        self.checkOutButton.setTitle("結帳", for: .normal)
        self.checkOutButton.setTitleColor(.white, for: .normal)
        self.checkOutButton.titleLabel?.font = UIFont(name: "System", size: 20)
        self.checkOutButton.backgroundColor = .systemRed
        
        queryFromPHP()
        signIn()

    }
    
    // MARK: - 設定開始時登入名字
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<products.count {
            let indexPath = IndexPath(row: i, section: 0)
                print("productProducts: \(self.products[indexPath.row].quantity!)")
            }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - 按鈕動作
    @IBAction func addtoCartButtonAction(_ sender: UIButton) {
        
        for i in 0..<self.products.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let productQ = self.products[indexPath.row].quantity,
               let cartQ = cart[indexPath.row].quantity {
                self.products[indexPath.row].quantity = "\(Int(productQ)! + Int(cartQ)!)"
            }
        }
        
        self.checkButton.isEnabled = true
        for i in 0..<self.products.count {
            let indexPath = IndexPath(row: i, section: 0)
            let rowQuantity = self.products[indexPath.row].quantity
            
            跳脫迴圈:
            if rowQuantity != "0", self.cartList.count == 0 {
                self.cartList.append(self.products[indexPath.row])
            } else if rowQuantity != "0", self.cartList.count != 0 {
                for rows in 0..<self.cartList.count {
                    let cartIndexPath = IndexPath(row: rows, section: 0)
                    if self.products[indexPath.row].productName == self.cartList[cartIndexPath.row].productName {
                        self.cartList[cartIndexPath.row].quantity = self.products[indexPath.row].quantity
                        break 跳脫迴圈
                    }
                }
                self.cartList.append(self.products[indexPath.row])
            }
        }

        let alertController = UIAlertController(title: nil, message: "已加入購物車", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func checkOutButtonAction(_ sender: UIButton) {
        self.checkButton.isEnabled = true
    }
    
    @IBAction func signBarButtonAction(_ sender: UIBarButtonItem) {
        
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userPhone")
        UserDefaults.standard.removeObject(forKey: "userAddress")
        if UserDefaults.standard.string(forKey: "userID") != nil {
            UserDefaults.standard.removeObject(forKey: "userID")
        }
        signIn()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cart.append(Cart())
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.nameText.text = products[indexPath.row].productName
        cell.descriptionText.text = products[indexPath.row].description
        cell.priceText.text = "$ \(products[indexPath.row].price)"
        let productImage = UIImage(named: products[indexPath.row].image)
        let resize = productImage?.resize(maxEdge: 1024)
        cell.productImageView.image = resize
        cell.numberTextField.text = self.cart[indexPath.row].quantity
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cartSegue" {
            if let cartListVC = segue.destination as? CartListViewController {
                cartListVC.cartProduct = self.cartList
                cartListVC.cartQuantity = self.cart
                cartListVC.productListProducts = self.products
                cartListVC.delegate = self
            }
        }
    }
    
    // MARK: - ProductCellDelegate
    func updateProduct(cell: ProductCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        self.cart[indexPath.row].quantity = cell.numberTextField.text
    }
    
    // MARK: - CartListViewControllerDelegate
    func updateTextFieldQuantity(Quantity: [Cart]) {
        for i in 0..<products.count {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? ProductCell
            cell?.stepperButton.value = 0
            cell?.numberTextField.text = "0"
        }
    }
    
    func didDeleteCartProduct(products: [Product], cartProduct: [Product]) {

        self.products = products
        self.cartList = cartProduct
    }
    
    // MARK: - 從MySQL下載資料
    func queryFromPHP() {
        
        if let url = URL(string: "http://b53168cf6a43.ngrok.io/shoppingcart/product_update_json.php") {
            let request = URLRequest(url: url)
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
                    self.products = try decorder.decode([Product].self, from: responseData)
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
    
    // MARK: - Sign
    func signIn() {
        let userName = UserDefaults.standard.string(forKey: "userName")
        let userPhone = UserDefaults.standard.string(forKey: "userPhone")
        let userAddress = UserDefaults.standard.string(forKey: "userAddress")
        if userName == nil, userPhone == nil {
            let alertController = UIAlertController(title: nil, message: "請輸入名字與電話號碼", preferredStyle: .alert)
            alertController.addTextField { (nameTextField) in
                nameTextField.placeholder = "請輸入你的名字"
            }
            alertController.addTextField { (phoneTextfield) in
                phoneTextfield.placeholder = "請輸入你的電話號碼"
            }
            alertController.addTextField { (addressTextfield) in
                addressTextfield.placeholder = "請輸入你的地址"
            }
            let action = UIAlertAction(title: "確定", style: .default) { [self] (action) in
                
                if let name = alertController.textFields?[0].text,
                   let phone = alertController.textFields?[1].text,
                   let address = alertController.textFields?[2].text {
                    if name == "" || phone == "" || address == "" {
                        let errorAlert = UIAlertController(title: nil, message: "請填完整資訊", preferredStyle: .alert)
                        let errorAction = UIAlertAction(title: "確定", style: .cancel) { (action) in
                            self.present(alertController, animated: true, completion: nil)
                        }
                        errorAlert.addAction(errorAction)
                        self.present(errorAlert, animated: true, completion: nil)
                    } else {
                        UserDefaults.standard.set(name, forKey: "userName")
                        UserDefaults.standard.set(phone, forKey: "userPhone")
                        UserDefaults.standard.set(address, forKey: "userAddress")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else {
            print("登入使用者名字為: \(userName!), 登入使用者電話為: \(userPhone!), 登入使用者地址為: \(userAddress!)")
        }
    }
    
}

extension Notification.Name {
    static let reset = Notification.Name("Reset")
}
