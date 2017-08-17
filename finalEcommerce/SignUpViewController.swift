//
//  SignUpViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/24/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Foundation

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpButton: UIButton!
    //reset default size
    var scrollViewHieght : CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
     let keychain = Keychain()
     var reg = false
    
    @IBAction func signUpButton_Pressed(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        if passwordTextField.text != passwordConfTextField.text {
            let alert = UIAlertController(title: "Error", message: "Password/Password Confirm do not match", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        print("register")
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfTextField.resignFirstResponder()
        fullNameTextField.resignFirstResponder()
        
        let headers = [
            "cache-control": "no-cache",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let passwordString = "&password=" + self.passwordTextField.text!
        let emailString = "&email=" + self.usernameTextField.text!
        let nameString = "&name=" + self.fullNameTextField.text!
        let addressString = "&address=" + self.emailTextField.text!
        let usernameString = "&username=" + self.webSiteTextField.text!
        let phoneString = "&phone=" + self.bioTextField.text!
        let postData = NSMutableData(data: emailString.data(using: String.Encoding.utf8)!)
        postData.append(passwordString.data(using: String.Encoding.utf8)!)
        postData.append(nameString.data(using: String.Encoding.utf8)!)
        postData.append(addressString.data(using: String.Encoding.utf8)!)
        postData.append(usernameString.data(using: String.Encoding.utf8)!)
        postData.append(phoneString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(connection.link)mregister")! as URL,
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
                        if(self.reg == false){
//                            self.keychain.setPasscode("password", passcode: self.passwordTextField.text!)
//                            self.keychain.setPasscode("email", passcode: self.usernameTextField.text!)
//                            self.performSegue(withIdentifier: "RegisterSeg", sender: self)
//                            self.reg = true
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "More")
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                        }
                        
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
    
    @IBAction func signInButton_Pressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
    
    func hexStringToUIColor (hex:String) -> UIColor {
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
        if (usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || passwordConfTextField.text!.isEmpty || emailTextField.text!.isEmpty || fullNameTextField.text!.isEmpty) {
            
            signUpButton.isEnabled = false
            signUpButton.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        } else {
            signUpButton.isEnabled = true
            signUpButton.setTitleColor(UIColor.white
                , for: UIControlState.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        //scroll view frame size
        scrollView.frame = CGRect(origin: CGPoint(x:0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        //scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHieght = scrollView.frame.size.height
        
        //check notification if keyboard is shown or not
//        NotificationCenter.defaultCenter.addObserver(self, selector: #selector(SignUpViewController.showKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NotificationCenter.defaultCenter.addObserver(self, selector: #selector(SignUpViewController.showKeyboard(notification:), name: UIKeybo
//        NotificationCenter.defaultCenter.addObserver(self, selector: #selector(SignUpViewController.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboardTap(recognizer:)))
        //hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
        
        
        
        signUpButton.isEnabled = false
        signUpButton.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        usernameTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        passwordConfTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        fullNameTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        //bioTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        //webSiteTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        self.signInButton.alpha = 1.0
        self.signInButton.layer.borderWidth = 1.2
        self.signInButton.layer.borderColor = UIColor(white: 0.7, alpha: borderAlpha).cgColor
        self.signInButton.layer.cornerRadius = cornerRadius
        self.signUpButton.layer.borderWidth = 1.2
        self.signUpButton.backgroundColor = UIColor.clear
        self.signUpButton.layer.borderColor = UIColor(white: 0.7, alpha: borderAlpha).cgColor
        self.signUpButton.layer.cornerRadius = cornerRadius
        self.signUpButton.alpha = 0.7
        
        backgroundColours = [hexStringToUIColor(hex: "#603697"), hexStringToUIColor(hex: "#1683fb"), hexStringToUIColor(hex: "#807f17")]
        backgroundLoop = 0
        self.animateBackgroundColour()
    }
    
    func animateBackgroundColour () {
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop+=1
        } else {
            backgroundLoop = 0
        }
        UIView.animate(withDuration: 10, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.scrollView.backgroundColor = self.backgroundColours[self.backgroundLoop]
            self.view.backgroundColor =  self.backgroundColours[self.backgroundLoop]
            self.signInButton.backgroundColor = self.backgroundColours[self.backgroundLoop]
            self.signInButton.alpha = 1.0
        }) {(Bool) -> Void in
            self.animateBackgroundColour();
        }
        
    }
    

    
    func hideKeyboardTap (recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func showKeyboard (notification: NSNotification){
        //keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        //move up UI
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHieght - self.keyboard.height
        }
    }
    
    func hideKeyboard (notification: NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
