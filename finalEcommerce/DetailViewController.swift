//
//  DetailViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/7/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import GMStepper

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var productName = ""
    var productDescription = ""
    var productPrice: Float = 0.0
    var productCat = ""
    var quantity: Float = 1
    var id = UserDefaults.standard.object(forKey: "productId")!
    @IBOutlet weak var detailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
        self.detailTableView.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
        detailTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func loadProduct () {
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mproduct/\(id)")!,
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
                            
                            //let string = String(data: data!, encoding: String.Encoding.utf8)
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                            let productObj = json["product"] as! [String: Any]
                            self.productName = productObj["name"] as! String
                            self.productPrice = productObj["price"] as! Float
                            self.productDescription = productObj["description"] as! String
                            
                            print(self.productDescription)
                            
                            
                            
                            self.detailTableView.reloadData()
                            
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
            infoCell.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
            infoCell.nameLabel.text = productName
            infoCell.categoryLabel.text  = ""
            infoCell.priceLabel.text = String("$\(self.productPrice)")
            infoCell.selectionStyle = UITableViewCellSelectionStyle.none
            return infoCell
        } else if indexPath.section == 1 {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
            buttonCell.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
            buttonCell.addToCartButton.backgroundColor = UIColor(colorLiteralRed: 0.898, green: 0.106, blue: 0.141, alpha: 1.00)
            buttonCell.addToCartButton.addTarget(self, action: #selector(DetailViewController.cartButtonPressed(sender:)), for: .touchUpInside)
            buttonCell.stepper.addTarget(self, action: #selector(DetailViewController.stepperValueChanged), for: .valueChanged)

            
        } else if indexPath.section == 2 {
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionTableViewCell
            descriptionCell.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
            descriptionCell.descriptionLabel.text = productDescription
            descriptionCell.selectionStyle = UITableViewCellSelectionStyle.none
            return descriptionCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return calculateHeightForString(inString: productName + "\n" + String("$\(productPrice)") + "\n" + "Shoes")
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 90
            }
        }
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                return calculateHeightForString(inString: productDescription)
            }
        }
        
        return 0
    }
    
    func calculateHeightForString(inString:String) -> CGFloat
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 1000))
        label.text = inString
        label.numberOfLines = 100
        label.font = UIFont(name: "System", size: 21.0)
        label.sizeToFit()
        return label.frame.height + 50
    }
    
    func stepperValueChanged(stepper: GMStepper) {
        self.quantity = Float(stepper.value)
        print("AAAAAAAAAAAA + \(stepper.value)")
    }
    
    func stepperButton(sender: ButtonTableViewCell) {
         quantity = Float(sender.stepper.value) //Here you save your updated value
        print("AAAAAAAAAAAA + \(sender.stepper.value)")
        }

    func cartButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        let totalPrice = productPrice * self.quantity
        let passwordString = "&productId=" + "\(id)"
        let emailString = "&priceTotal=" + String("\(totalPrice) ")
        let nameString = "&quantity=" + "\(self.quantity)"
        let postData = NSMutableData(data: emailString.data(using: String.Encoding.utf8)!)
        postData.append(passwordString.data(using: String.Encoding.utf8)!)
        postData.append(nameString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)mproduct/\(id)")! as URL,
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
                        //segue to main view, etc.
                        
                        let alert = UIAlertController(title: "Message", message: "\(Int(self.quantity)) item(s) added to cart", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                        
                        let tab = TabbarController()
                        tab.loadData(completionHandler: { (ok) -> Void in
                            if ok {
                                self.tabBarController?.tabBar.items?[3].badgeValue = "\(tab.count)"
                            }
                        })

                        
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
    
    
}
