//
//  IdentityManagementViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/4.
//

import UIKit

class IdentityManagementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
    }

    @IBAction func SaveQrImg(_ sender: UIButton) {
        let qrImg = Wallet.WInst.qrCodeImage!
        
        UIImageWriteToSavedPhotosAlbum(qrImg, nil, nil, nil)
        
        showToast(message: "保存成功")
    }
}
