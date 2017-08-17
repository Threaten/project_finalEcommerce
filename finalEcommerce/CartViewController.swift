//
//  CartViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/24/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Kingfisher

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var idList: Array <String> = Array <String>()
    var nameList: Array <String> = Array <String>()
    var priceList: Array <Float> = Array <Float>()
    var imgList: Array <String> = Array <String>()
    var quantityList: Array <Int> = Array <Int>()
    var totalQuantity: Int = 0
    var price: Float = 0
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    @IBAction func checkoutButton_Pressed(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "checkout") as! CheckoutViewController
        vc.totalPrice = price
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadData () {
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mcart")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if (httpResponse?.statusCode == 200){
                    DispatchQueue.main.async(execute: {
                        do {
                            self.nameList.removeAll()
                            self.priceList.removeAll()
                            self.imgList.removeAll()
                            self.quantityList.removeAll()
                            self.idList.removeAll()
                            self.price = 0
                            self.totalQuantity = 0
                            //let string = String(data: data!, encoding: String.Encoding.utf8)
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                            
                            if let cartList = json["items"] as? NSArray {
                                for  i in 0..<cartList.count  {
                                    if let cartObj = cartList[i] as? NSDictionary {
                                        let totalPrice = cartObj["price"] as? Float
                                        self.priceList.append(totalPrice!)
                                        self.price = self.price + totalPrice!
                                        let quantity = cartObj["quantity"] as? Int
                                        self.quantityList.append(quantity!)
                                        self.totalQuantity = self.totalQuantity + quantity!
                                        let itemId = cartObj["_id"] as? String
                                        self.idList.append(itemId!)
                                        let productDetail = cartObj["item"] as? NSDictionary
                                        let itemName = productDetail?["name"] as? String
                                        self.nameList.append(itemName!)
                                        let itemImg = productDetail?["img1"] as? String
                                        self.imgList.append(itemImg!)
                                        
                                    }
                                }
                                let tab = TabbarController()
                                tab.loadData(completionHandler: { (ok) -> Void in
                                    if ok {
                                        self.tabBarController?.tabBar.items?[3].badgeValue = "\(tab.count)"
                                    }
                                })

                                self.tblView.reloadData()
                                if self.idList.isEmpty {
                                    self.checkoutButton.isEnabled = false
                                } else {
                                    self.checkoutButton.isEnabled = true
                                }
                            }
                            
                        } catch {
                            print("json error1: \(error)")
                        }
                    })
                }else{
                    print("error")
                }
                // use anyObj here
                print("json error2: \(error)")
            }
        }
        
        dataTask.resume()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        _ = (cell as! CartItemTableViewCell).nameLabel.text = nameList[indexPath.row]
        _ = (cell as! CartItemTableViewCell).priceLabel.text = String("$\(priceList[indexPath.row])")
        _ = (cell as! CartItemTableViewCell).quantityLabel.text = String("\(quantityList[indexPath.row])")
        let urlString = "\(connection.link)public/uploads/\(nameList[indexPath.row])\(imgList[indexPath.row])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: urlString!)

        _ = (cell as! CartItemTableViewCell).imgView.kf.setImage(with: url, placeholder: nil,
                                                        options: [.transition(ImageTransition.fade(1)), .forceRefresh],
                                                        progressBlock: { receivedSize, totalSize in
                                                            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                                        completionHandler: { image, error, cacheType, imageURL in
                                                            print("\(indexPath.row + 1): Finished")
        })
        _ = (cell as! CartItemTableViewCell).removeButton.addTarget(self, action: #selector(CartViewController.removeButtonPressed(sender:)), for: .touchUpInside)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CartItemTableViewCell
        cell.imgView.kf.indicatorType = .activity
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CartFooterCell
        cell.itemLabel.text = "\(totalQuantity)"
        cell.priceLabel.text = "$\(price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func removeButtonPressed(sender: UIButton) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? CartItemTableViewCell {
                    indexPath = tblView.indexPath(for: cell) as NSIndexPath!
                }
            }
        }
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        let item = "item=" + self.idList[indexPath.row]
        let price = "&price=" + "\(self.priceList[indexPath.row])"
        let postData = NSMutableData(data: item.data(using: String.Encoding.utf8)!)
        postData.append(price.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)mcartRemove")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if (httpResponse?.statusCode == 200){
                    DispatchQueue.main.async(execute: {
                        print(item)
                        let tab = TabbarController()
                        tab.loadData(completionHandler: { (ok) -> Void in
                            if ok {
                                self.tabBarController?.tabBar.items?[3].badgeValue = "\(tab.count)"
                            }
                        })
                        self.loadData()
                        
                    })
                }else{
                    print("error")
                }
                // use anyObj here
                print("json error: \(error)")
            }
        })
        
        dataTask.resume()

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

