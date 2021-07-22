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
    
    public static func getIsUnlock() -> Bool {
        if !IosLibLoadCard(WInst.walletJSON) {
            print("load card faild")
            return false
        }
        return IosLibIsOpen()
    }
    
    public static func NewAcc(auth: String) -> Bool {
        guard let jsonData = IosLibNewCard(auth) else {
            return false
        }
        
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
    
    public static func DeriveAesKey(auth: String) -> Bool {
        
        let derive_key = IosLibDeriveAesKey(auth)
        
        KeychainWrapper.standard.set(derive_key, forKey: "AESKey")

        return true
    }
    
    public static func UnlockAcc(auth: String?) -> Bool {
        let time_stamp: Int64 = Date().time_stamp
        let location = DataShareManager.sharedInstance.requestLocation()
        let lang: Double = location["latitude"] ?? 0
        let long: Double = location["longitude"] ?? 0
        print("LOCATION=====>\(lang),\(long)")
        var jsonData: [String: String] = [:]
        jsonData["longitude"] = String(long)
        jsonData["latitude"] = String(lang)
        jsonData["time_stamp"] = String(time_stamp)
        jsonData["did"] = self.WInst.did

        let signMsg = IosLibSignMessage(self.WInst.did, lang, long, time_stamp)

        if !IosLibLoadCard(WInst.walletJSON) {
            print("load card faild")
            return false
        }
        if !IosLibIsOpen() {
            if auth == nil {
                if let AesKey = KeychainWrapper.standard.string(forKey: "AESKey") {
                    if IosLibOpenWithAesKey(AesKey) != "" {
                        print("AESKey false")
                        return false
                    }
                } else {
                    print("AESKey not in keychain")
                    return false
                }
            } else {
                if !IosLibOpen(auth) {
                    print("can not open wallet")
                    return false
                }
            }
            
        }
        print("jsonMsg\(signMsg)")
        
        let signReturnData = IosLibSign(signMsg)
        let signString = signReturnData
        jsonData["sig"] = signString
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
//        print("init by json \(String(describing: self.did))")
//        print("init by json \(String(describing: self.walletJSON))")
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
