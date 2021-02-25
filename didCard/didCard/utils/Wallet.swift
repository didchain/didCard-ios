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

class Wallet: NSObject {
    var did:String?
    var walletJSON:String?
    
    var coreData:CDWallet?
    
    var hasAccount:Bool = true
    
    public static var WInst = Wallet()
    
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    override init() {
        
        super.init()
        var core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDWallet") as? CDWallet
        guard let jsonStr = core_data!.walletJSON, jsonStr != "" else {
            hasAccount = false
            return
        }
        
        self.did = core_data!.did
        self.walletJSON = core_data!.walletJSON
        coreData = core_data
    }
    
    public static func NewAcc(auth: String) -> Bool {
        guard let jsonData = IosLibNewCard(auth) else {
            return false
        }
        print("jsonData is \(jsonData)")
        populateWallet(data: jsonData)
        self.WInst.hasAccount = true
        return true
    }
    
    public static func ImportAcc(auth: String, json: String) -> Bool {
        guard (IosLibImport(auth, json) != nil) else {
            return false
        }
        populateWallet(data: Data(json.utf8))
        
        return true
    }
    
    public func initByJson(_ jsonData:Data){
        let jsonObj = JSON(jsonData)
        self.did = jsonObj["did"].string
        self.walletJSON = jsonObj["walletJSON"].string
        
        print("init by json \(String(describing: self.did))")
    }
    
    private static func populateWallet(data: Data) {
        WInst.initByJson(data)

        guard let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDWallet") as? CDWallet else { return }
        
        print("findentity\(core_data)")
        
        core_data.setValue(String(data: data, encoding: .utf8), forKey: "walletJSON")
        core_data.setValue(WInst.did, forKey: "did")
//        core_data.walletJSON = String(data: data, encoding: .utf8)
//        core_data.did = WInst.did

        WInst.coreData = core_data
        
        DataShareManager.sharedInstance.saveContext()
        
    }
    
}
