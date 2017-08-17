//
//  ProductsViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/27/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//


//https://serene-brook-72340.herokuapp.com
//https://serene-brook-72340.herokuapp.com
import UIKit
import Kingfisher

class ProductsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var imageList: Array <String> = Array <String>()
    var priceList: Array <NSNumber> = Array <NSNumber>()
    var idList: Array <String> = Array <String>()
    var nameList: Array <String> = Array <String>()
    var id: String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        productsCollectionView = UICollectionView()
        loadData()
        UserDefaults.standard.removeObject(forKey: "productId")
        UserDefaults.standard.synchronize()
        
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
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mproducts/\(id)")!,
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
                            self.idList.removeAll()
                            self.imageList.removeAll()
                            self.priceList.removeAll()
                            //let string = String(data: data!, encoding: String.Encoding.utf8)
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as Any
                            if let productsList = json as? NSArray {
                                for  i in 0..<productsList.count  {
                                    if let productObj = productsList[i] as? NSDictionary {
                                        let productName = productObj["name"] as? String
                                        self.nameList.append(productName!)
                                        let productPrice = productObj["price"] as? NSNumber
                                        self.priceList.append(productPrice!)
                                        let productImage = productObj["img1"] as? String
                                        self.imageList.append(productImage!)
                                        let productId = productObj["_id"] as? String
                                        self.idList.append(productId!)

                                    
                                        
                                    
                                }
                            }
                            //self.tblView.reloadData()
                            //print(self.categoryID)
                            print(self.nameList.count)
                            print(self.imageList.count)
                            print(self.priceList.count)
                            self.productsCollectionView.reloadData()
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

 override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! ProductsCell).imgView.kf.cancelDownloadTask()

    }


 override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return nameList.count
}
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let urlString = "\(connection.link)public/uploads/\(nameList[indexPath.row])\(imageList[indexPath.row])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: urlString!)

        _ = (cell as! ProductsCell).nameLabel.text = nameList[indexPath.row]
        _ = (cell as! ProductsCell).priceLabel.text = String("$\(priceList[indexPath.row])")
        
                print(url)
        _ = (cell as! ProductsCell).imgView.kf.setImage(with: url, placeholder: nil,
                                                         options: [.transition(ImageTransition.fade(1)), .forceRefresh],
                                                         progressBlock: { receivedSize, totalSize in
                                                            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                                         completionHandler: { image, error, cacheType, imageURL in
                                                            print("\(indexPath.row + 1): Finished")
        })

    }

 override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductsCell
    cell.imgView.kf.indicatorType = .activity
    return cell
}
    
    
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/2.0 //Display Three elements in a row.
        collectionViewSize.height = collectionViewSize.height/2
        return collectionViewSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(self.idList[indexPath.row], forKey: "productId")
        UserDefaults.standard.synchronize()   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! ProductsCell
            if let indexPath = self.collectionView!.indexPath(for: cell) {
                let controller = segue.destination as! ProductDetailViewController
                //let review = ReviewTableViewCell()
//                review.id = self.idList[indexPath.row]
                controller.id = self.idList[indexPath.row]
                //UserDefaults.standard.set(self.idList[indexPath.row], forKey: "productId")
                //UserDefaults.standard.synchronize()
                //print(defaults.object(forKey: "someObject"))
                //controller.title = self.nameList[indexPath.row]
            }
        }
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
