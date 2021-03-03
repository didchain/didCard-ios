//
//  Wallet.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/8.
//

import Foundation
import IosLib
import SwiftyJSON
import CoreData
import UIKit
import CoreImage.CIFilterBuiltins

class Wallet: NSObject {
    var did:String?
    var walletJSON:String?
    var coreData:CDWallet?
    var qrCodeImage:UIImage?
    var qrCodeSignImage:UIImage?
    var isLocked:Bool = true
    var hasAccount:Bool = true
    
    public static var WInst = Wallet()
    
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    override init() {
        super.init()
        guard let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDWallet") as? CDWallet, core_data.walletJSON != nil else {
            self.hasAccount = false
            return
        }

        guard let jsonStr = core_data.walletJSON, jsonStr != "" else {
            return
        }
        
        
        
        self.did = core_data.did
        self.walletJSON = core_data.walletJSON
        self.qrCodeImage = DataShareManager.sharedInstance.generateQRCode(from: self.walletJSON!)

        coreData = core_data
    }
    
    public static func NewAcc(auth: String) -> Bool {
        guard let jsonData = IosLibNewCard(auth) else {
            return false
        }
        print("jsonData is \(jsonData)")
        populateWallet(data: jsonData)
        _ = UnlockAcc(auth: auth)
        let not = Notification.init(name: Notification.Name("ACCOUNT_CREATED"))
        NotificationCenter.default.post(not)
        return true
    }
    
    public static func ImportAcc(auth: String, json: String) -> Bool {
        guard (IosLibImport(auth, json) != nil) else {
            return false
        }
        populateWallet(data: Data(json.utf8))
        let not = Notification.init(name: Notification.Name("ACCOUNT_CREATED"))
        NotificationCenter.default.post(not)
        _ = UnlockAcc(auth: auth)
        return true
    }
    
    public static func UnlockAcc(auth: String) -> Bool {
        let time_stamp: Int64 = Date().time_stamp
        let location = DataShareManager.sharedInstance.requestLocation()
        let lang: Double = location["latitude"] ?? 0
        let long: Double = location["longitude"] ?? 0
        var jsonData: [String: Any] = [:]
        jsonData["did"] = self.WInst.did
        jsonData["latitude"] = lang
        jsonData["longitude"] = long
        jsonData["time_stamp"] = time_stamp

        let data = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
        let jsonMsg: String = String(data: data!, encoding: .utf8)!
        
//        print("WInst.walletJSON\(WInst.walletJSON)")
        
        if IosLibIsOpen() {
            print("wallet is open")
        } else {
            guard IosLibLoadCard(WInst.walletJSON) else {
                print("load card faild")
                return false
            }
            
            guard IosLibOpen(auth) else {
                print("can not open wallet")
                return false
            }
        }
        
        guard let signReturnData = IosLibSign(jsonMsg) else {
            print("sign failed")
            return false
        }
        
        let signString = signReturnData.base64EncodedString()
        jsonData["signature"] = signString
        let qrData = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
        let qrString: String = String(data: qrData!, encoding: .utf8)!
        let qrImg = DataShareManager.sharedInstance.generateQRCode(from: qrString)
        self.WInst.isLocked = false
        self.WInst.qrCodeSignImage = qrImg
        
        return true
    }
    
    public func initByJson(_ jsonData:Data){
        let jsonObj = JSON(jsonData)
        self.did = jsonObj["did"].string
        let jsonString: String = String(data: jsonData, encoding: .utf8)!
        self.walletJSON = jsonString
        let img: UIImage = DataShareManager.sharedInstance.generateQRCode(from: jsonString)!
        self.qrCodeImage = img
        self.isLocked = false
        print("init by json \(String(describing: self.did))")
        print("init by json \(String(describing: self.walletJSON))")
    }
    
    private static func populateWallet(data: Data) {
        WInst.initByJson(data)

        let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDWallet") as? CDWallet
            core_data!.walletJSON = String(data: data, encoding: .utf8)
            core_data!.did = WInst.did
        WInst.coreData = core_data
        DataShareManager.sharedInstance.saveContext()

    }
    
}

extension Date {
    var time_stamp: Int64 {
        let timeInterval = self.timeIntervalSince1970
        let time_stamp = Int64(timeInterval)
        return time_stamp
    }
}
