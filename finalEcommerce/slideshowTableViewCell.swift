//
//  slideshowTableViewCell.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/4/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import ImageSlideshow

class slideshowTableViewCell: UITableViewCell {

        var id = UserDefaults.standard.object(forKey: "productId")!
    @IBOutlet weak var slideshow: ImageSlideshow!
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    var imgSource = [KingfisherSource(urlString: "bio.png")!]

    var img1: String = ""
    var img2: String = ""
    var img3: String = ""
    var img4: String = ""
    var img5: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(slideshowTableViewCell.click))
        slideshow.addGestureRecognizer(recognizer)
        loadProduct()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
                            self.img1 = productObj["img1"] as! String
                            self.img2 = productObj["img2"] as! String
                            self.img3 = productObj["img3"] as! String
                            self.img4 = productObj["img4"] as! String
                            self.img5 = productObj["img5"] as! String
                            
                            
                            self.imgSource = [KingfisherSource(urlString: self.img1)!,KingfisherSource(urlString: self.img2)!,KingfisherSource(urlString: self.img3)!,KingfisherSource(urlString: self.img4)!,KingfisherSource(urlString: self.img5)!]
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

//    
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
        self.window?.rootViewController?.present(ctr, animated: true, completion: nil)
    }

}
