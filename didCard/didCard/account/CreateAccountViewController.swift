//
//  CreateAccountViewController.swift
//  didCard
//
//  Created by wesley on 2021/2/2.
//

import UIKit

class CreateAccountViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var _delegate: UIGestureRecognizerDelegate?

    @IBOutlet weak var PassWrod2FD: UITextField!
    @IBOutlet weak var PassWrod1FD: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController?.viewControllers.count)! >= 1 {
            _delegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = _delegate
    }
    
    @IBAction func CreateAccount(_ sender: UIButton) {
        guard PassWrod1FD.text == PassWrod2FD.text else {
            print("两次输入密码不同")
            return
        }

        
        guard let password = PassWrod1FD.text, password != "" else {
            return
        }
        
        if false == Wallet.NewAcc(auth: password) {
            return
        } else {
            print("\(String(describing: Wallet.WInst.did))")
        }

        self.performSegue(withIdentifier: "CreateSuccessSeg", sender: self)
    }
    
        
}

