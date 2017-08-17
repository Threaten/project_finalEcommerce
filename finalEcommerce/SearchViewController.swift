//
//  SearchViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/24/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var imageList: Array <String> = Array <String>()
    var priceList: Array <NSNumber> = Array <NSNumber>()
    var idList: Array <String> = Array <String>()
    var nameList: Array <String> = Array <String>()
    var id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(SearchViewController.getHintsFromTextField),
            object: searchBar)
        self.perform(
            #selector(SearchViewController.getHintsFromTextField),
            with: searchBar,
            afterDelay: 0.5)
        return true

    }
    
    
    func getHintsFromTextField(searchBar: UISearchBar) {
        loadData(inString: searchBar.text!)
    }
    
    func loadData (inString:String) {
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        let searchString = "query=" + "\(inString)"
        
        let postData = NSMutableData(data: searchString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)msearch")! as URL,
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
                                self.productCollectionView.reloadData()
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
        })
        
        dataTask.resume()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! ProductsCell).imgView.kf.cancelDownloadTask()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        _ = (cell as! ProductsCell).nameLabel.text = nameList[indexPath.row]
        _ = (cell as! ProductsCell).priceLabel.text = String("$\(priceList[indexPath.row])")
        let urlString = "\(connection.link)public/uploads/\(nameList[indexPath.row])\(imageList[indexPath.row])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: urlString!)
        _ = (cell as! ProductsCell).imgView.kf.setImage(with: url, placeholder: nil,
                                                        options: [.transition(ImageTransition.fade(1))],
                                                        progressBlock: { receivedSize, totalSize in
                                                            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                                        completionHandler: { image, error, cacheType, imageURL in
                                                            print("\(indexPath.row + 1): Finished")
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! ProductDetailViewController
        detail.id = idList[indexPath.row]
        UserDefaults.standard.set(self.idList[indexPath.row], forKey: "productId")
        UserDefaults.standard.synchronize()
        self.navigationController?.pushViewController(detail, animated: true)
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
