//
//  Utils.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/3/1.
//

import UIKit
import IosLib
import SwiftyJSON

class Utils: NSObject {
    private override init() {
        super.init()
    }

    public func PostNoti(_ namedNoti: Notification) {
        NotificationCenter.default.post(namedNoti)
    }
    
    public static func VerifyLogin(_ randToken: String, _ authUrl: String) -> Bool {
        let signMsg = IosLibSignUserLoginMessage(Wallet.WInst.did, randToken, authUrl)
        
        print("\(signMsg)")
        
        let sig = IosLibSign(signMsg)
        
        let url = URL(string: "http://39.99.198.143:60998/api/verify")
        var request = URLRequest.init(url: url!)
        request.httpMethod = "POST"

        let params:NSDictionary = ["content":[
            "auth_url": authUrl,
            "random_token": randToken,
            "did": Wallet.WInst.did
            ],
        "sig": sig
        ]
        print("\(params)")

        let paramData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = paramData
        
        var resCode:Bool = false
        let postTask = URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if (data != nil) && err == nil {
                let jsonData = JSON(data!)
                
                print("data++++\(jsonData)")
                if jsonData["result_code"] == 0 {
                    resCode = true
                } else {
                    resCode = false
                }
            } else {
                resCode = false
            }
        }
        postTask.resume()
        return resCode
    }
}
