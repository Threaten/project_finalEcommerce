//
//  SignInViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/24/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    typealias CompletionHandler = (_ success:Bool) -> Void
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let socket = SocketIOClient(socketURL: URL(string:"\(connection.link)")!)
    var loggedIn = false;
    let keychain = Keychain()
    var userData = NSDictionary()
    
    
    @IBAction func signInButton_Pressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Enpty Username/Password", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        self.loginRequestWithParams(self.emailTextField.text!, passwordString: self.passwordTextField.text!, completionHandler: { (success) -> Void in
            
            // When download completes,control flow goes here.
            if success {
                let tab =  TabbarController()
                tab.loadData(completionHandler: { (ok) -> Void in
                    if ok {
                        self.tabBarController?.tabBar.items?[3].badgeValue = "\(tab.count)"                        
                    }
                })
            } else {
                // download fail
            }
        })

        
    }
    @IBAction func signUpButton_Pressed(_ sender: UIButton) {
    }
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.7)
        )
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            signInButton.isEnabled = false
            signInButton.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        } else {
            signInButton.isEnabled = true
            signInButton.setTitleColor(UIColor.white, for: UIControlState())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
        signInButton.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        hideKeyboardWhenTappedAround()

        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        self.signUpButton.alpha = 1.0
        self.signUpButton.layer.borderWidth = 1.2
        self.signUpButton.layer.borderColor = UIColor(white: 0.7, alpha: borderAlpha).cgColor
        self.signUpButton.layer.cornerRadius = cornerRadius
        self.signInButton.layer.borderWidth = 1.2
        self.signInButton.backgroundColor = UIColor.clear
        self.signInButton.layer.borderColor = UIColor(white: 0.7, alpha: borderAlpha).cgColor
        self.signInButton.layer.cornerRadius = cornerRadius
        self.signInButton.alpha = 0.7
        
        backgroundColours = [hexStringToUIColor("#603697"), hexStringToUIColor("#1683fb"), hexStringToUIColor("#807f17")]
        backgroundLoop = 0
        self.animateBackgroundColour()
        
        super.viewDidLoad()
        self.socket.connect()
        self.addSocketHandlers()
        self.loggedIn = false;
        
        //comment below to force login
        
//        if self.keychain.getPasscode("password")! != "" && self.keychain.getPasscode("email")! != "" {
//            self.loginRequestWithParams(self.keychain.getPasscode("email") as! String, passwordString: self.keychain.getPasscode("password") as! String)
//        }

    }
    
    func animateBackgroundColour () {
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop+=1
        } else {
            backgroundLoop = 0
        }
        UIView.animate(withDuration: 10, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.backgroundColor =  self.backgroundColours[self.backgroundLoop];
            self.signUpButton.backgroundColor = self.backgroundColours[self.backgroundLoop];
            self.signUpButton.alpha = 1.0
        }) {(Bool) -> Void in
            self.animateBackgroundColour();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addSocketHandlers(){
        // Our socket handlers go here
        socket.on("connect") {data, ack in
            print("socket connected")
        }
    }
    func loginRequestWithParams(_ usernameString : String, passwordString : String,completionHandler: @escaping CompletionHandler){
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let emailStr = "email=" + usernameString
        let passwordStr = "&password=" + passwordString
        var postData = NSData(data: emailStr.data(using: String.Encoding.utf8)!) as Data
        postData.append(passwordStr.data(using: String.Encoding.utf8)!)
        
        var request = URLRequest(url: URL(string: "\(connection.link)mlogin")!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {data, response, error -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if (httpResponse?.statusCode == 200){
                    DispatchQueue.main.async(execute: {
                        //segue to main view.
                        if(self.keychain.getPasscode("password") == "" || self.keychain.getPasscode("email") == ""){
                            self.keychain.setPasscode("password", passcode: passwordString)
                            self.keychain.setPasscode("email", passcode: usernameString)
                        }   
                        if (self.loggedIn == false){
                            self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "profile"))!, animated: true)
                            // use anyObj here
                            completionHandler(true)
                            self.loggedIn = true;
                        }else{ 
                            
                        }
                    })
                } else if httpResponse?.statusCode == 400 {
                    let alert = UIAlertController(title: "Error", message: "Wrong Email/Password", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                // use anyObj here
                print("json error: \(error)")
            }
        }
        
        dataTask.resume()
        
    }
    
    func logout() {
        let headers = [
            "cache-control": "no-cache",
            ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)mlogout")!,
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
                        //segue to main view.
                        self.loggedIn = false
                    })
                }else{
                    print("error")
                }
                // use anyObj here
                print("json error: \(error)")
            }
        }
        
        dataTask.resume()
        
    }
    
    func completelyLogout() {
        let headers = [
            "cache-control": "no-cache",
            ]
        
        
        var request = URLRequest(url: URL(string: "\(connection.link)logout")!,
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
                        //segue to main view.
                        self.loggedIn = false
                        UserDefaults.standard.set("" as String, forKey: "userId")
                        UserDefaults.standard.synchronize()
                        self.keychain.setPasscode("passowrd", passcode: "")
                        self.keychain.setPasscode("email", passcode: "")

                    })
                }else{
                    print("error")
                }
                // use anyObj here
                print("json error: \(error)")
            }
        }
        
        dataTask.resume()
        
    }
    
    func login(_ usernameString : String, passwordString : String,completionHandler: @escaping CompletionHandler){
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let emailStr = "email=" + usernameString
        let passwordStr = "&password=" + passwordString
        var postData = NSData(data: emailStr.data(using: String.Encoding.utf8)!) as Data
        postData.append(passwordStr.data(using: String.Encoding.utf8)!)
        
        var request = URLRequest(url: URL(string: "\(connection.link)mlogin")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {data, response, error -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if (httpResponse?.statusCode == 200){
                    DispatchQueue.main.async(execute: {
                        //segue to main view.
                        self.loggedIn = true
                                            })
                } else if httpResponse?.statusCode == 400 {
                    let alert = UIAlertController(title: "Error", message: "Wrong Email/Password", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                // use anyObj here
                print("json error: \(error)")
            }
        }
        
        dataTask.resume()
        
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
