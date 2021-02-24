//
//  CDWallet+CoreDataProperties.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/24.
//
//

import Foundation
import CoreData


extension CDWallet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWallet> {
        return NSFetchRequest<CDWallet>(entityName: "CDWallet")
    }

    @NSManaged public var did: String?
    @NSManaged public var walletJSON: String?

}
