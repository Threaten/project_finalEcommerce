//
//  FeaturedViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/20/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var featuredCollectionView: UITableView!
    var tableData: Array <String> = Array <String>()
    var categoryID: Array <String> = Array <String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        //featuredCollectionView.register(FeaturedTableViewCell.self, forCellReuseIdentifier: "featuredCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // your function here
            self.loadData()
            self.featuredCollectionView.reloadData()
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let featuredCell = tableView.dequeueReusableCell(withIdentifier: "featuredCell", for: indexPath) as! FeaturedTableViewCell
        featuredCell.id = categoryID[indexPath.row]
        return featuredCell
    }
    
    func loadData () {
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mcategories")!,
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
                            self.tableData.removeAll()
                            self.categoryID.removeAll()
                            //let string = String(data: data!, encoding: String.Encoding.utf8)
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as Any
                            if let categoriesList = json as? NSArray {
                                for  i in 0..<categoriesList.count  {
                                    if let categoryObj = categoriesList[i] as? NSDictionary {
                                        if let categoryName = categoryObj["name"] as? String {
                                            //print(categoryName)
                                            self.tableData.append(categoryName)
                                            print("TEST + \(categoryObj["_id"] as! String)")
                                            self.categoryID.append((categoryObj["_id"] as? String)!)
                                        }
                                    }
                                }
                                self.featuredCollectionView.reloadData()
                                
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

}
