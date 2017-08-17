//
//  TabbarController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/7/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    typealias CompletionHandler = (_ success:Bool) -> Void
    var dataTable: Array <String> = Array <String>()
    var count: Int = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        loadData()
        //        setBadge()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadData (completionHandler: @escaping CompletionHandler){
        
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
                            
                            //let string = String(data: data!, encoding: String.Encoding.utf8)
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                            
                            if let cartList = json["items"] as? NSArray {
                                self.count = cartList.count
                                print(self.count)
                                completionHandler(true)
                            }
                            
                        } catch {
                            print("json error1: \(error)")
                        }
                    })
                }else{
                    //let login = SignInViewController()
                    //login.completelyLogout()
                    let alert = UIAlertController(title: "Error", message: "Your session has expired", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                // use anyObj here
                print("json error2: \(error)")
            }
        }
        
        dataTask.resume()
    }
    
    func setBadge() {
        loadData(completionHandler: { (ok) -> Void in
            if ok {
                self.tabBar.items?[3].badgeValue = "\(self.count)"
            }
        })
    }
    
    func setBadge2() {
        self.tabBar.items?[3].badgeValue = "5"
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
