//
//  ProffileTableViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/18/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class ProffileTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBAction func changeAvatarButton_Pressed(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButon_Pressed(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "More"))!, animated: true)
    }
    
    @IBAction func doneButton_Pressed(_ sender: UIBarButtonItem) {
        updateUserInfo()
        updateImage()
        loadData()
    }
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    var edited: Bool = false
    var user = NSDictionary()
    
    func textViewDidChange(_ textView: UITextView) {
        edited = true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        edited = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.tableView.backgroundColor = UIColor(colorLiteralRed: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        tableView.tableFooterView = UIView()
        
        tableView.beginUpdates()
        
        hideKeyboardWhenTappedAround()

        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(ProffileTableViewController.loadImage(recognizer:)))
        avaTap.numberOfTapsRequired = 1
        userAvatar.isUserInteractionEnabled = true
        userAvatar.addGestureRecognizer(avaTap)
        
        loadData()
        tableView.endUpdates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 5
        } else if section == 2 {
            return 3
        }
        return 0
    }
    
    func loadData() {
        let headers = [
            "cache-control": "no-cache",
            ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mprofile")!,
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
                            let string = String(data: data!, encoding: String.Encoding.utf8)
                            print("lol + \(string)")
                            //let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            self.user = json!
                            UserDefaults.standard.set(self.user.object(forKey: "_id") as? String, forKey: "userId")
                            UserDefaults.standard.synchronize()
                            //print(self.user.object(forKey: "_id") as? String)
                            //self.email.text = self.user.objectForKey("email") as? String
                            self.usernameTextField.text = self.user.object(forKey: "username") as? String
                            self.nameTextField.text = self.user.object(forKey: "name") as? String
                            self.addressTextField.text = self.user.object(forKey: "address") as? String
                            self.phoneTextField.text = self.user.object(forKey: "phone") as? String
                            self.emailTextField.text = self.user.object(forKey: "email") as? String
                            
                            self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2
                            self.userAvatar.clipsToBounds = true
                            
                            let avatar = URL(string: "\(connection.link)public/uploads/\(self.user.object(forKey: "_id")!).jpg")!
                            print(avatar)
                            self.userAvatar.kf.setImage(with: avatar, placeholder: nil,
                                                        options: [.transition(ImageTransition.fade(1)), .forceRefresh])
                            
                            self.tableView.reloadData()
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
    
    
    func loadImage () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.cropMode = .circular
        present(picker, animated: true, completion: nil)
    }
    
    
    func loadImage (recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.cropMode = .circular
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userAvatar.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUserInfo() {
        self.view.endEditing(true)
        
        
        if currentPasswordTextField.text != newPasswordConfirmTextField.text {
            let alert = UIAlertController(title: "Error", message: "Password/Password Confirm do not match", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        currentPasswordTextField.resignFirstResponder()
        newPasswordConfirmTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let passwordString = "&password=" + "1"
        let addressString = "&address=" + self.addressTextField.text!
        let phoneString = "&phone=" + self.phoneTextField.text!
        let nameString = "&name=" + self.nameTextField.text!
        let postData = NSMutableData(data: nameString.data(using: String.Encoding.utf8)!)
        postData.append(passwordString.data(using: String.Encoding.utf8)!)
        postData.append(phoneString.data(using: String.Encoding.utf8)!)
        postData.append(addressString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)meditProfile")! as URL,
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
    
    func updateImage() {
        let URL = "\(connection.link)meditProfile"
        //let image = UIImageJPEGRepresentation(userAvatar.image!, 0.5)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let image = self.userAvatar.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                        multipartFormData.append(imageData, withName: "image", fileName: "avatar.jpg", mimeType: "image/jpeg")
                    }
                }
            },
            to: URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
