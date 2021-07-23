//
//  OrderFormViewController.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/7/4.
//

import UIKit

class OrderFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var orderList: [OrderForm] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        queryOrderFromPHP()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderFormCell", for: indexPath) as! OrderFormCell
        cell.orderDateLabel.text = "訂單日期: \(self.orderList[indexPath.row].orderDate)"
        cell.orderPriceLabel.text = "總金額: \(self.orderList[indexPath.row].totalAmount)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let orderDetailVC = segue.destination as? OrderFormDetailViewController,
               let indexPath = self.tableView.indexPathForSelectedRow {
                let order = self.orderList[indexPath.row]
                orderDetailVC.orderDetail = order
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - 從MySQL下載OrderForm資料
    func queryOrderFromPHP() {
        
        if let url = URL(string: "http://b53168cf6a43.ngrok.io/shoppingcart/orderForm_update_json.php") {
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
                    self.orderList = try decorder.decode([OrderForm].self, from: responseData)
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
