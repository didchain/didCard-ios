//
//  NewAccountViewController.swift
//  didCard
//
//  Created by wesley on 2021/2/2.
//

import UIKit

class NewAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
