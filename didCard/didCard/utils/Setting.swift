//
//  Setting.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/3/3.
//

import UIKit
import Foundation
import CoreData

class Setting: NSObject {
    var useFaceID: Bool?
    var withoutAuth: Bool?
    var coreData: CDSetting?
    
    public static var SettingInst = Setting()
    
    override init() {
        super.init()
        
        let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDSetting") as? CDSetting
        self.useFaceID = core_data?.useFaceID
        self.withoutAuth = core_data?.withoutAuth
        self.coreData = core_data
    }
    
    public static func getUseFaceID() -> Bool {
        guard let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDSetting") as? CDSetting else {
            return SettingInst.useFaceID!
        }
        return core_data.useFaceID
    }
    
    public static func getWithoutAuth() -> Bool {
        guard let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDSetting") as? CDSetting else {
            return SettingInst.withoutAuth!
        }
        return core_data.withoutAuth
    }
    
    public static func setUseFaceID(_ used: Bool) {
        let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDSetting") as? CDSetting
        core_data?.useFaceID = used
        DataShareManager.sharedInstance.saveContext()
    }
    
    public static func setWithoutAuth(_ used: Bool) {
        let core_data = DataShareManager.sharedInstance.findEntity(forEntityName: "CDSetting") as? CDSetting
        core_data?.withoutAuth = used
        DataShareManager.sharedInstance.saveContext()
    }
    
}
