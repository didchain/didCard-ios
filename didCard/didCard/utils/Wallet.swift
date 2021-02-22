//
//  Wallet.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/8.
//

import Foundation
import IosLib
import SwiftyJSON

class Wallet: NSObject {
    
    var time_stamp:Int64?
    var latitude:Double?
    var longitude:Double?
    var signature:String?
    var did:String?
    
    public static var WInst = Wallet()
    
    override init() {
        super.init()
        
        
        
    }
    func NewAcc(pwd: String) -> Bool {
//        guard let jsonData = IosLibNewCard(pwd) else { return false }
//        let jsonObj = JSON(jsonData)
//        self.did = jsonObj["did"].string
//        self.latitude = jsonObj["latitude"].double
//        self.longitude = jsonObj["longitude"].double
//        self.signature = jsonObj["signature"].string
//        self.time_stamp = jsonObj["time_stamp"].int64
        
        
//        guard let jsonObj = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: AnyObject]] else {
//            return false
//        }
//        print(jsonObj)
        return true
    }
}

