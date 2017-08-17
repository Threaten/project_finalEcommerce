//
//  CheckoutViewController.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 10/19/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {

    var totalPrice: Float = 0.0
    
    @IBAction func payButton_Pressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "stripe") as! StripeTableViewController
        vc.totalPrice = totalPrice
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
