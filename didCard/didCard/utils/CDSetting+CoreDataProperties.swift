//
//  CDSetting+CoreDataProperties.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/3/3.
//
//

import Foundation
import CoreData


extension CDSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSetting> {
        return NSFetchRequest<CDSetting>(entityName: "CDSetting")
    }

    @NSManaged public var withoutAuth: Bool
    @NSManaged public var useFaceID: Bool

}
