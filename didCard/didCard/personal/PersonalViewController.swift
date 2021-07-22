//
//  PersonalViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/4.
//

import UIKit
import LocalAuthentication

class PersonalViewController: UIViewController {

    @IBOutlet weak var FaceID: UISwitch!
    @IBOutlet weak var Auth: UISwitch!
    @IBOutlet weak var did: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        did.text = Wallet.WInst.did
        Auth.isOn = Setting.getWithoutAuth()
        FaceID.isOn = Setting.getUseFaceID()
    }
    
    @IBAction func Auth(_ sender: UISwitch) {
        if sender.isOn {
            showInputDialog(title: "验证密码",
                            message: Wallet.WInst.did!,
                            textPlaceholder: "请输入密码",
                            actionText: "确定",
                            cancelText: "取消",
                            cancelHandler: nil) { (text: String?) in
                if Wallet.UnlockAcc(auth: text ?? "") && Wallet.DeriveAesKey(auth: text ?? "") {
                    Setting.setWithoutAuth(true)
                }
            }
        } else {
            Setting.setWithoutAuth(false)
        }
    }
    
    @IBAction func FaceID(_ sender: UISwitch) {
        if sender.isOn {
            showInputDialog(title: "验证密码",
                            message: Wallet.WInst.did!,
                            textPlaceholder: "请输入密码",
                            actionText: "确定",
                            cancelText: "取消",
                            cancelHandler: nil) { (text: String?) in
                if !(Wallet.UnlockAcc(auth: text ?? "") && Wallet.DeriveAesKey(auth: text ?? "")) {
                    Setting.setUseFaceID(false)
                    sender.setOn(false, animated: true)
                    print("derive key faild")
                    return
                }
            }

            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "是否允许App使用您的\(context.biometryType)"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self](success, authError) in
                    DispatchQueue.main.async {
                        if success {
                            Setting.setUseFaceID(true)
                        } else {
                            let ac = UIAlertController(title: "验证失败", message: "请重试", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                            self?.present(ac, animated: true, completion: nil)
                            Setting.setUseFaceID(false)
                            sender.setOn(false, animated: true)
                        }
                    }
                }
            } else {
                let ac = UIAlertController(title: "设备不支持", message: "您的设备不支持FaceID/TouchID", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
                Setting.setUseFaceID(false)
                sender.setOn(false, animated: true)
            }
        } else {
            Setting.setUseFaceID(false)
        }
        
    }
    
}
