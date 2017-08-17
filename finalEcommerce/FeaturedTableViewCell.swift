//
//  FeaturedTableViewCell.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/20/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Kingfisher

class FeaturedTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var id: String = ""
    var imageList: Array <String> = Array <String>()
    var priceList: Array <NSNumber> = Array <NSNumber>()
    var idList: Array <String> = Array <String>()
    var nameList: Array <String> = Array <String>()
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Initialization code
        self.collectionView.contentSize = CGSize(width: self.collectionView.frame.width, height: 182)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // your function here
            self.loadData()
            self.collectionView.contentSize = CGSize(width: self.collectionView.frame.width * CGFloat(self.idList.count / 3), height: 181)

        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        _ = (cell as! FeaturedCollectionViewCell).productNameLabel.text = nameList[indexPath.row]
        _ = (cell as! FeaturedCollectionViewCell).productPriceLabel.text = String("$\(priceList[indexPath.row])")
        let urlString = "\(connection.link)public/uploads/\(nameList[indexPath.row])\(imageList[indexPath.row])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: urlString!)

        _ = (cell as! FeaturedCollectionViewCell).imgView.kf.setImage(with: url, placeholder: nil,
                                                        options: [.transition(ImageTransition.fade(1))],
                                                        progressBlock: { receivedSize, totalSize in
                                                            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                                        completionHandler: { image, error, cacheType, imageURL in
                                                            print("\(indexPath.row + 1): Finished")
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! FeaturedCollectionViewCell
        cell.imgView.kf.indicatorType = .activity
        return cell
    }
    
    func loadData () {
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mfeatured/\(id)")!,
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
                                self.collectionView.reloadData()
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  let detail = UIViewController() as! ProductDetailViewController
       // detail.id = idList[indexPath.row]
       UserDefaults.standard.set(self.idList[indexPath.row], forKey: "productId")
       UserDefaults.standard.synchronize()
        //self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "featuredSegue" {
            let cell = sender as! ProductsCell
            if let indexPath = self.collectionView!.indexPath(for: cell) {
                let controller = segue.destination as! ProductDetailViewController
                //let review = ReviewTableViewCell()
                //                review.id = self.idList[indexPath.row]
                print("AAAAAA" +  (self.idList[indexPath.row]))
                controller.id = self.idList[indexPath.row]
                UserDefaults.standard.set(self.idList[indexPath.row], forKey: "productId")
                UserDefaults.standard.synchronize()
                //UserDefaults.standard.set(self.idList[indexPath.row], forKey: "productId")
                //UserDefaults.standard.synchronize()
                //print(defaults.object(forKey: "someObject"))
                //controller.title = self.nameList[indexPath.row]
            }
        }
    }


}
