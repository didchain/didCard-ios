//
//  DataShareManager.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/24.
//

import UIKit
import CoreData
import CoreLocation

class DataShareManager: NSObject, CLLocationManagerDelegate {
    
    public static var sharedInstance = DataShareManager()
    
    var locationManager:CLLocationManager!

    
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
    
    lazy var manageedContext = self.persistentContainer.viewContext
    
    // MARK: - NSManagedObject
    
    func findEntity(forEntityName:String) -> NSManagedObject? {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: forEntityName)
        fetchRequest.fetchLimit = 1
//        var result: NSManagedObject?
    
        do {
            let ret = try managedContext.fetch(fetchRequest)
            
            guard let result = ret.last as? NSManagedObject else {
                let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: managedContext)!
                return NSManagedObject(entity: entity, insertInto: managedContext)
            }

            return result
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func generateQRCode(from message: String) -> UIImage? {
            
            guard let data = message.data(using: .utf8) else{
                    return nil
            }
            
            guard let qr = CIFilter(name: "CIQRCodeGenerator",
                                    parameters: ["inputMessage":
                                    data, "inputCorrectionLevel":"M"]) else{
                    return nil
            }
            
            guard let qrImage = qr.outputImage?.transformed(by: CGAffineTransform(scaleX: 5, y: 5)) else{
                    return nil
            }
            let context = CIContext()
            let cgImage = context.createCGImage(qrImage, from: qrImage.extent)
            let uiImage = UIImage(cgImage: cgImage!)
            return uiImage
    }
    
    func requestLocation() -> [String: Double] {

        self.locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        
        if CLLocationManager.authorizationStatus() == .denied {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        var data: [String: Double] = [:]
        
        guard let mylocation:CLLocationCoordinate2D = locationManager.location?.coordinate else {
            return data
        }
        
        data["latitude"] = mylocation.latitude
        data["longitude"] = mylocation.longitude
        print("latitude && longitude \(data)")
    
        return data
        
    }
    
}

