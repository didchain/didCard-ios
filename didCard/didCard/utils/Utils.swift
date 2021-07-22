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
    
    public static func getAccessableList(onResult: @escaping(JSON?) -> Void) {
        var result:JSON?
//        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "http://39.99.198.143:60998/api/hostList")!
       
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                return
            }
            if let resData = data {
                let jsonData = JSON(resData)
                result = jsonData["data"]
                onResult(result)
//                semaphore.signal()
            }
            
        }.resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

    }
    
    public static func VerifyLogin(_ randToken: String, _ authUrl: String, username: String, password: String) -> Bool {
        let signMsg = IosLibSignUserLoginMessage(Wallet.WInst.did, randToken, authUrl)
        
        let sig = IosLibSign(signMsg)
        
        let url = URL(string: "http://39.99.198.143:60998/api/verify")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        let params:NSDictionary = [
            "content":[
                "auth_url": authUrl,
                "random_token": randToken,
                "did": Wallet.WInst.did
            ],
            "ext_data":[
                "user_name": username,
                "password": password
            ],
            "sig": sig
        ]

        let httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = httpBody
        
        var resCode:Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if (data != nil) && err == nil {
                let jsonData = JSON(data!)
                if jsonData["result_code"] == 0 {
                    resCode = true
                }
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return resCode
    }
}
