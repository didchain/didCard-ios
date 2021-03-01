//
//  QRCodeViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/4.
//

import UIKit
typealias UnlockCallBack = ()->()
class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var PasswordFD: UITextField!
    var delegate:UnlockCallBack?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }

    @IBAction func Unlock(_ sender: UIButton) {
        if PasswordFD.text == "" {
            print("密码不得为空")
            return
        }
        
        if false == Wallet.UnlockAcc(auth: PasswordFD.text!) {
            print("解锁失败")
            return
        }
        delegate?()
        self.dismiss(animated: true, completion: nil)
    }
}
