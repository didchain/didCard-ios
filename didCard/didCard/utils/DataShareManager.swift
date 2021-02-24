//
//  DataShareManager.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/24.
//

import UIKit
import CoreData

class DataShareManager: NSObject {
    
    public static var sharedInstance = DataShareManager()
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DIDBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - NSManagedObject
    
    func findEntity(forEntityName:String) -> NSManagedObject {
        let managedContext = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: managedContext)!
        let result = NSManagedObject(entity: entity, insertInto: managedContext)
        return result
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }}
