//
//  Keychain.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/24/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Security

let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword);
let kSecClassValue = NSString(format: kSecClass);
let kSecAttrServiceValue = NSString(format: kSecAttrService);
let kSecValueDataValue = NSString(format: kSecValueData);
let kSecMatchLimitValue = NSString(format: kSecMatchLimit);
let kSecReturnDataValue = NSString(format: kSecReturnData);
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne);
let kSecAttrAccountValue = NSString(format: kSecAttrAccount);

class Keychain: NSObject {
    func setPasscode(_ identifier: String, passcode: String) {
        let dataFromString: Data = passcode.data(using: String.Encoding.utf8)!;
        let keychainQuery = NSDictionary(
            objects: [kSecClassGenericPasswordValue, identifier, dataFromString],
            forKeys: [kSecClassValue, kSecAttrServiceValue, kSecValueDataValue]);
        SecItemDelete(keychainQuery as CFDictionary);
        let status : OSStatus = SecItemAdd(keychainQuery as CFDictionary, nil);
        print (status)
    }
    func getPasscode(_ identifier: String) -> NSString? {
        let keychainQuery = NSDictionary(
            objects: [kSecClassGenericPasswordValue, identifier, kCFBooleanTrue, kSecMatchLimitOneValue],
            forKeys: [kSecClassValue, kSecAttrServiceValue, kSecReturnDataValue, kSecMatchLimitValue]);
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var passcode: NSString!;
        if (status == errSecSuccess) {
            let retrievedData: Data? = dataTypeRef as? Data
            if let result = NSString(data: retrievedData!, encoding: String.Encoding.utf8.rawValue) {
                passcode = result as NSString
            }
        }
        else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
            
        }
        return passcode;
    }
    
}

