//
//  ReviewTableViewCell.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/4/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewTableViewCell: UIViewController {
    
    var id = UserDefaults.standard.object(forKey: "productId")!
    var titleList: Array <String> = Array <String>()
    var contentList: Array <String> = Array <String>()
    var authorList: Array <String> = Array <String>()
    var emailList: Array <String> = Array <String>()
    var avaList: Array <String> = Array <String>()
    var datetimeList: Array <String> = Array <String>()
    @IBOutlet weak var reviewTableView: UITableView!
    override func awakeFromNib() {
        print("REVIEW REVIEW" + String(describing: id) + "review")
        loadComment()
        super.awakeFromNib()
        // Initialization code
        
        reviewTableView.tableFooterView = UIView()
        //reviewTableView.register(UITableViewCell.self, forCellReuseIdentifier: "revireCell")
        
    }
    
    func loadComment () {
        
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
                            self.titleList.removeAll()
                            //let string = String(data: data!, encoding: String.Encoding.utf8)
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                            if let commentList = json["comment"] as? NSArray {
                                for  i in 0..<commentList.count  {
                                    if let commentObj = commentList[i] as? NSDictionary {
                                        let title = commentObj["title"] as? String
                                        self.titleList.append(title!)
                                        let commment = commentObj["content"] as? String
                                        self.contentList.append(commment!)
                                        let datetime = commentObj["createdAt"] as? String
                                        self.datetimeList.append(datetime!)
                                        let userDetail = commentObj["user"] as? NSDictionary
                                        let authorName = userDetail?["name"] as? String
                                        self.authorList.append(authorName!)
                                        let authorEmail = userDetail?["email"] as? String
                                        self.emailList.append(authorEmail!)
                                        let authorAva = userDetail?["image"] as? String
                                        self.avaList.append(authorAva!)
                                        
                                    }
                                }
                            }
                            print(self.titleList.count)
                            
                            
                            self.reviewTableView.reloadData()
                            
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userReview", for: indexPath) as! IndividualReviewTableViewCell
        cell.titleLabel.text = titleList[indexPath.row]
        let shortdate = convertDateFormater(date: datetimeList[indexPath.row])
        cell.authorLabel.text = "by \(authorList[indexPath.row]) (\(emailList[indexPath.row])) \n at \(shortdate)"
        let url = URL(string: avaList[indexPath.row])
        cell.imgView.kf.setImage(with: url, placeholder: nil,
                                 options: [.transition(ImageTransition.fade(1))],
                                 progressBlock: { receivedSize, totalSize in
                                    print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                 completionHandler: { image, error, cacheType, imageURL in
                                    print("\(indexPath.row + 1): Finished")
        })
        cell.contentLabel.text = contentList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.white
    }
    
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
}
