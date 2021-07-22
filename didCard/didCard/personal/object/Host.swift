//
//  Host.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/4/14.
//

import UIKit

class Host: NSObject {
    var accounts:[CDAccounts]?
    
    public static var HostInst = Host()
    
    override init() {
        super.init()
        reloadData()
    }
    
    func reloadData() {
        let w = NSPredicate(format: "website != nil AND account != nil AND password != nil")
        
        let core_data = DataShareManager.sharedInstance.findEntities(forEntityName: "CDAccounts", w: w) as? [CDAccounts]?
        self.accounts = core_data as? [CDAccounts]
    }
    
    public static func isExist(website :String) -> CDAccounts? {
        for host in HostInst.accounts! {
            if website == host.website && host.isUsed {
                return host
            }
        }
        return nil
    }
    
    public static func getHostList() -> [CDAccounts] {
        HostInst.reloadData()
        return HostInst.accounts!
    }
    
    public static func cancelUsed(_ data: CDAccounts) {

        let website:String = data.website!
        let username:String = data.account!
        
        let w = NSPredicate(format: "website==%@ AND account==%@", website, username)
        var accountInst:CDAccounts?
        
        accountInst = DataShareManager.sharedInstance.findOneEntity("CDAccounts", where: w) as? CDAccounts
        
        accountInst?.isUsed = false
        DataShareManager.sharedInstance.saveContext()

    }
    
    public static func setUsed(_ data: CDAccounts, force: Bool) {
        let website:String = data.website!
        let username:String = data.account!
        
        let w = NSPredicate(format: "website==%@", website)
        var accountInsts:[CDAccounts]?
        
        accountInsts = DataShareManager.sharedInstance.findEntities(forEntityName: "CDAccounts", w: w) as? [CDAccounts]
        var hasUsed = false

        if let dataInsts = accountInsts {
            for dataInst in dataInsts {
                if dataInst.isUsed && dataInst.account != username {
                    hasUsed = true
                    if force {
                        dataInst.isUsed = false
                    }
                }
                if dataInst.account == username {
                    dataInst.isUsed = true
                }
            }
            if hasUsed && !force {
                for dataInst in dataInsts {
                    if dataInst.account == username {
                        dataInst.isUsed = false
                    }
                }
            }
            
            DataShareManager.sharedInstance.saveContext()
        }

    }
    
    
    
    public static func addUpdateHost(host: String, username: String, password: String) {
        let w = NSPredicate(format: "website==%@ AND account==%@", host, username)
        
        var accountInst:CDAccounts?
        accountInst = DataShareManager.sharedInstance.findOneEntity("CDAccounts", where: w) as? CDAccounts
        
        if (accountInst?.website != nil && accountInst?.account != nil) {
            //update
            accountInst?.password = password
        } else {
            //new
            accountInst?.website = host
            accountInst?.account = username
            accountInst?.password = password
            if let i = accountInst {
                setUsed(i, force: false)
            }
        }
        
        DataShareManager.sharedInstance.saveContext()
        
        HostInst.reloadData()
    }
    
    public static func delHost(host: String, username: String, password: String) {
        
        let w = NSPredicate(format: "website == %@ AND account == %@ AND password == %@", host, username, password)
        
        let accountInst = DataShareManager.sharedInstance.findOneEntity("CDAccounts", where: w) as? CDAccounts
        
        if accountInst != nil {
            DataShareManager.sharedInstance.deleteContext(entity: accountInst!)
            HostInst.reloadData()
        }
        
    }

}
