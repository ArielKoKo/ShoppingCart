//
//  CartListViewController.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/26.
//

import UIKit

protocol CartListViewControllerDelegate: AnyObject {
    func updateTextFieldQuantity(Quantity: [Cart])
    func didDeleteCartProduct(products: [Product], cartProduct: [Product])
}

class CartListViewController: UIViewController, UITableViewDataSource, CartCellDelegate {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    var cartProduct: [Product]!
    var cartQuantity :[Cart]!
    var productListProducts: [Product]!
    var totalQuantity: Int = 0
    var totalPrice: Int = 0
    weak var delegate: CartListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        for i in 0..<self.cartQuantity.count {
            let indexPath = IndexPath(row: i, section: 0)
            self.cartQuantity[indexPath.row].quantity = "0"
        }
        
        updateTotalPriceAndQuantity()
        
        self.cartTableView.dataSource = self
        self.orderButton.setTitle("送出訂單", for: .normal)
        
        for i in 0..<self.cartQuantity.count {
            let indexPath = IndexPath(row: i, section: 0)
            print("刪除前的cartQuantity \(self.cartQuantity[indexPath.row].quantity!)")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.updateTextFieldQuantity(Quantity: self.cartQuantity)
        for i in 0..<self.cartQuantity.count {
            let indexPath = IndexPath(row: i, section: 0)
            self.cartQuantity[indexPath.row].quantity = "0"
        }
    }
    
    // MARK: - 按鍵動作
    
    @IBAction func orderButtonAction(_ sender: UIButton) {
        if self.cartProduct.count == 0 {
            let alerController = UIAlertController(title: nil, message: "購物車沒有任何商品", preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alerController.addAction(action)
            present(alerController, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "orderSegue", sender: self)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let cartImage = UIImage(named: self.cartProduct[indexPath.row].image)
        let resize = cartImage?.resize(maxEdge: 1024)
        cell.cartImageView.image = resize
        cell.cartNameLabel.text = self.cartProduct[indexPath.row].productName
        cell.cartPriceLabel.text = "$ \(self.cartProduct[indexPath.row].price)"
        cell.cartQuantityTextField.text = self.cartProduct[indexPath.row].quantity
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderSegue" {
            if let orderVC = segue.destination as? OrderListViewController {
                orderVC.orderProduct = self.cartProduct
                orderVC.totalOrderPrice = self.totalPrice
                orderVC.totalOrderQuantity = self.totalQuantity
            }
        }
    }
    
    // MARK: - CartCellDelegate
    func updateCart(cell: CartCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        if cell.cartQuantityTextField.text == "0" {
            let alert = UIAlertController(title: "確定刪除？", message: nil, preferredStyle: .alert)
            let checkAction = UIAlertAction(title: "確定", style: .default) { (action) in
                for i in 0..<self.productListProducts.count {
                    let index = IndexPath(row: i, section: 0)
                    if cell.cartNameLabel.text == self.productListProducts[index.row].productName {
                        self.cartQuantity[index.row].quantity = "-1"
                        self.productListProducts[index.row].quantity = "0"
                    }
                }
                self.cartProduct.remove(at: indexPath.row)
                self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
                self.delegate?.didDeleteCartProduct(products: self.productListProducts, cartProduct: self.cartProduct)
                self.updateTotalPriceAndQuantity()
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(checkAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        } else {
            cartProduct[indexPath.row].quantity = cell.cartQuantityTextField.text
            updateTotalPriceAndQuantity()
        }
    }
    
    
    func updateTotalPriceAndQuantity() {
        self.totalQuantity = 0
        self.totalPrice = 0
        for i in 0..<self.cartProduct.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let quantity = self.cartProduct[indexPath.row].quantity {
                let price = self.cartProduct[indexPath.row].price
                totalQuantity = totalQuantity + Int(quantity)!
                totalPrice = totalPrice + Int(price)! * Int(quantity)!
            }
        }
        self.totalQuantityLabel.text = "總數量為: \(String(totalQuantity))"
        self.totalPriceLabel.text = "總金額為: \(String(totalPrice))"
    }

  

}
