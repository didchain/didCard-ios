//
//  ViewController.swift
//  didCard
//
//  Created by wesley on 2021/1/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


