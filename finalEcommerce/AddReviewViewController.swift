//
//  AddReviewViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/12/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController, UITextViewDelegate {

    var id = UserDefaults.standard.object(forKey: "productId")!
    var userId = UserDefaults.standard.object(forKey: "userId")!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.delegate = self
        
        commentTextView.layer.borderColor = UIColor.init(colorLiteralRed: 0.835, green: 0.835, blue: 0.835, alpha: 1.00).cgColor
        commentTextView.layer.borderWidth = 0.5;
        commentTextView.layer.cornerRadius = 5.0;
        
        commentTextView.text = "Review"
        commentTextView.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.textColor == UIColor.lightGray {
            commentTextView.text = ""
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.isEmpty {
            commentTextView.text = "Review"
            commentTextView.textColor = UIColor.lightGray
        }
    }

    @IBAction func sendButtonPressed(_ sender: UIBarButtonItem) {
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        let productIdString = "&productId=" + "\(id)"
        let userIdString = "&_id=" + "\(userId)"
        let titleString = "&title=" + titleTextField.text!
        let reviewString = "&content=" + commentTextView.text
        let postData = NSMutableData(data: userIdString.data(using: String.Encoding.utf8)!)
        postData.append(productIdString.data(using: String.Encoding.utf8)!)
        postData.append(reviewString.data(using: String.Encoding.utf8)!)
        postData.append(titleString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)mproduct/\(id)/comment")! as URL,
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
                        self.navigationController?.popViewController(animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
