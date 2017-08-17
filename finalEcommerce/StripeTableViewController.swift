//
//  StripeTableViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/20/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class StripeTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var cvCodeTextField: UITextField!
    @IBOutlet weak var expiredYearTextField: UITextField!
    @IBOutlet weak var expMonthTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    var totalPrice: Float = 0.0
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBAction func payButton_Pressed(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let priceString = "stripeTotal=" + "\(totalPrice)"
        let cardString = "&cardNumber=" + "\(self.cardNumberTextField.text!)"
        let extMonthString = "&expMonth=" + "\(self.expMonthTextField.text!)"
        let expYearString = "&expYear=" + "\(self.expiredYearTextField.text!)"
        let cvCodeString = "&cvc=" + "\(self.cvCodeTextField.text!)"
        let postData = NSMutableData(data: priceString.data(using: String.Encoding.utf8)!)
        postData.append(cardString.data(using: String.Encoding.utf8)!)
        postData.append(extMonthString.data(using: String.Encoding.utf8)!)
        postData.append(expYearString.data(using: String.Encoding.utf8)!)
        postData.append(cvCodeString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)mpayment")! as URL,
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
                        let tab = TabbarController()
                        tab.loadData(completionHandler: { (ok) -> Void in
                            if ok {
                                self.tabBarController?.tabBar.items?[3].badgeValue = "\(tab.count)"
                            }
                        })

                        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "More"))!, animated: true)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.backgroundColor = UIColor(colorLiteralRed: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        tableView.tableFooterView = UIView()
        
        cardNumberTextField.delegate = self
        expMonthTextField.delegate = self
        expiredYearTextField.delegate = self
        cvCodeTextField.delegate = self
        priceLabel.text = "Total price: $\(totalPrice)"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if cardNumberTextField.text ==  "" ||  cardNumberTextField.text == " " {
//            payButton.isEnabled = false
//        } else if expiredYearTextField.text ==  "" ||  expiredYearTextField.text == " " {
//            payButton.isEnabled = false
//        } else if expMonthTextField.text ==  "" ||  expMonthTextField.text == " " {
//            payButton.isEnabled = false
//        } else if cvCodeTextField.text ==  "" ||  cvCodeTextField.text == " " {
//            payButton.isEnabled = false
//        } else {
//            payButton.isEnabled = true
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else {
            return 1
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
