//
//  MoreViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/24/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var keychain = Keychain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            if self.keychain.getPasscode("password")! != "" && self.keychain.getPasscode("email")! != "" {
                return 4
            } else {
                return 2
            }
        } else if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let cell = UITableViewCell()
        if self.keychain.getPasscode("password")! != "" && self.keychain.getPasscode("email")! != "" {
            if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = "My Account"
            } else if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1 {
                cell.textLabel?.text = "History"
            } else if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 2 {
                cell.textLabel?.text = "Wishlist"
            } else if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 3 {
                cell.textLabel?.text = "Logout"
                cell.textLabel?.textColor = UIColor.red
            } else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = "About"
            } else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1 {
                cell.textLabel?.text = "Terms and Conditions"
            }
        } else {
            if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = "Login"
            } else if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1 {
                cell.textLabel?.text = "Register"
            } else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = "About"
            } else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1 {
                cell.textLabel?.text = "Terms and Conditions"
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = (indexPath as NSIndexPath).row
        let section = (indexPath as NSIndexPath).section
        
        if self.keychain.getPasscode("password")! != "" && self.keychain.getPasscode("email")! != "" {
            if section == 0 && row == 0 {
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "profile"))!, animated: true)
            } else if section == 0 && row == 2 {
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "wishlist"))!, animated: true)
            } else if section == 0 && row == 3 {
                let alert = UIAlertController(title: "Do you want to logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"No", style: UIAlertActionStyle.cancel, handler: nil))
                let log = UIAlertAction(title: "Logout", style: UIAlertActionStyle.destructive) { (_) -> Void in
                    let headers = [
                        "cache-control": "no-cache",
                        ]
                    
                    
                    var request = URLRequest(url: URL(string: "\(connection.link)logout")!,
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
                                    //segue to main view.
                                    UserDefaults.standard.set("" as? String, forKey: "userId")
                                    UserDefaults.standard.synchronize()
                                    self.keychain.setPasscode("passowrd", passcode: "")
                                    self.keychain.setPasscode("email", passcode: "")
                                    self.tblView.reloadData()
                                })
                            }else{
                                print("error")
                            }
                            // use anyObj here
                            print("json error: \(error)")
                        }
                    }
                    
                    dataTask.resume()
                }
                alert.addAction(log)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if section == 0 && row == 0 {
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "signIn"))!, animated: true)
            } else if section == 0 && row == 1 {
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "signUp"))!, animated: true)
            } else if section == 1 && row == 0 {
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "about"))!, animated: true)
            } else if section == 0 && row == 1 {
                self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "ToS"))!, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Account"
        } else {
            return "About"
        }
    }
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
