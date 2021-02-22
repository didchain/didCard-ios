//
//  CreateAccountViewController.swift
//  didCard
//
//  Created by wesley on 2021/2/2.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var PassWrod2FD: UITextField!
    @IBOutlet weak var PassWrod1FD: UITextField!
    override func viewDidLoad() {
    super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func CreateAccount(_ sender: UIButton) {
            
        //TODO::
        //lib create account
        //result
        
        if PassWrod1FD.text != PassWrod2FD.text {
            print("两次输入密码不同")
            return
        }
        
        guard let password = PassWrod1FD.text, password != "" else {
            return
        }
        
        self.performSegue(withIdentifier: "CreateSuccessSeg", sender: self)
    }
        
        
}

