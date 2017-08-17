//
//  ProductDetailViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/1/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var wishlistButton: UIBarButtonItem!
    

    @IBOutlet weak var containerView: UIView!
    @IBAction func wishlistButton_Pressed(_ sender: UIBarButtonItem) {
        if isAdded == true {
            let headers = [
                "cache-control": "no-cache",
                "content-type": "application/x-www-form-urlencoded"
            ]
            let productString = "&item=" + "\(id)"
            
            let postData = NSMutableData(data: productString.data(using: String.Encoding.utf8)!)
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)mwishlistRemove")! as URL,
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
                            
                            let alert = UIAlertController(title: "Message", message: "Removed from wishlist", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.isAdded = false
                            self.wishlistButton.image = #imageLiteral(resourceName: "wishlist")
                            
                        })
                    }else{
                        print("error")
                    }
                    // use anyObj here
                    print("json error: \(error)")
                }
            })
            
            dataTask.resume()

        } else {
            let headers = [
                "cache-control": "no-cache",
                "content-type": "application/x-www-form-urlencoded"
            ]
             let productString = "&productId=" + "\(id)"

            let postData = NSMutableData(data: productString.data(using: String.Encoding.utf8)!)
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)mproduct/\(id)/wishlist")! as URL,
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
                            
                            let alert = UIAlertController(title: "Message", message: "Added to wishlist", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.isAdded = true
                            self.wishlistButton.image = #imageLiteral(resourceName: "wishlistAdded")
                            
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
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    //    @IBOutlet weak var reviewTableView: UITableView!
    //
    //    @IBAction func addToCartButton(_ sender: UIButton) {
    //    }
    //    @IBOutlet weak var priceLabel: UILabel!
    //    @IBOutlet weak var desciptionLabel: UILabel!
    //    @IBOutlet weak var productContentView: UIView!
    //    @IBOutlet weak var productScrollView: UIScrollView!
    //    @IBOutlet weak var addToCartButtonOutlet: UIButton!
    //    @IBOutlet weak var categoryLabel: UILabel!
    //    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet weak var slideshow: ImageSlideshow!
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    //
    var idList: Array <String> = Array <String>()
    var id: String = ""
    var img1: String = ""
    var img2: String = ""
    var img3: String = ""
    var img4: String = ""
    var img5: String = ""
    var name: String = ""
    
    var isAdded: Bool = false
    
    var imgSource = [KingfisherSource(urlString: "bio.png")!]
    
    
    weak var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        self.containerView.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
        loadProduct()
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "subDetail") as! DetailViewController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailViewController.click))
        slideshow.addGestureRecognizer(recognizer)
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadWishlist()
        loadProduct()
    }
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "subDetail") as! DetailViewController
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "subReview") as! ReviewViewController
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        }
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
        })
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        parentView.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func loadProduct () {
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        if id == "" {
            id = UserDefaults.standard.object(forKey: "productId")! as! String
        }
        
        
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
                            self.img1 = productObj["img1"] as! String
                            self.img2 = productObj["img2"] as! String
                            self.img3 = productObj["img3"] as! String
                            self.img4 = productObj["img4"] as! String
                            self.img5 = productObj["img5"] as! String
                            self.name = productObj["name"] as! String
                            
                            let urlString1 = "\(connection.link)public/uploads/\(self.name)\(self.img1)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            let url1 = URL(string: urlString1!)
                            let urlString2 = "\(connection.link)public/uploads/\(self.name)\(self.img2)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            let url2 = URL(string: urlString2!)
                            let urlString3 = "\(connection.link)public/uploads/\(self.name)\(self.img3)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            let url3 = URL(string: urlString3!)
                            let urlString4 = "\(connection.link)public/uploads/\(self.name)\(self.img4)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            let url4 = URL(string: urlString4!)
                            let urlString5 = "\(connection.link)public/uploads/\(self.name)\(self.img5)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            let url5 = URL(string: urlString5!)
                            
                            
                            
                            self.imgSource = [KingfisherSource(urlString: urlString1!)!,KingfisherSource(urlString: urlString2!)!,KingfisherSource(urlString: urlString3!)!,KingfisherSource(urlString: urlString4!)!,KingfisherSource(urlString: urlString5!)!]
                            self.slideshow.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.937, blue: 0.937, alpha: 1.00)
                            self.slideshow.slideshowInterval = 5.0
                            self.slideshow.pageControlPosition = PageControlPosition.insideScrollView
                            self.slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white;
                            self.slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray;
                            self.slideshow.contentScaleMode = UIViewContentMode.scaleToFill
                            self.slideshow.scrollView.isScrollEnabled = true
                            self.slideshow.scrollView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
                            self.slideshow.setImageInputs(self.imgSource)
                            
                            
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
    
    func loadWishlist () {
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mwishlist")!,
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
                            self.idList.removeAll()
                            //let string = String(data: data!, encoding: String.Encoding.utf8)
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                            if let wishlist = json["items"] as? NSArray {
                                for  i in 0..<wishlist.count  {
                                    if let wishlistObj = wishlist[i] as? NSDictionary {
                                        let productDetail = wishlistObj["item"] as? NSDictionary
                                        let item = productDetail?["_id"] as? String
                                        self.idList.append(item!)
                                    }
                                }
                            }
                            
                            if self.idList.contains(self.id) {
                                self.isAdded = true
                                self.wishlistButton.image = #imageLiteral(resourceName: "wishlistAdded")
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
    
    
    
    func click() {
        let ctr = FullScreenSlideshowViewController()
        ctr.pageSelected = {(page: Int) in
            self.slideshow.setScrollViewPage(page, animated: false)
        }
        
        ctr.initialImageIndex = slideshow.scrollViewPage
        ctr.inputs = slideshow.images
        slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: slideshow, slideshowController: ctr)
        // Uncomment if you want disable the slide-to-dismiss feature on full screen preview
        // self.transitionDelegate?.slideToDismissEnabled = false
        ctr.transitioningDelegate = slideshowTransitioningDelegate
        self.present(ctr, animated: true, completion: nil)
    }
    
}

