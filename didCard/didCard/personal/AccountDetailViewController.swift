//
//  AccountDetailViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/26.
//

import UIKit

class AccountDetailViewController: UIViewController {

    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var Did: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        QRCodeImageView.layer.borderWidth = 2
        QRCodeImageView.layer.borderColor = UIColor.init(red: 245/255, green: 201/255, blue: 92/255, alpha: 1).cgColor

        QRCodeImageView.image = Wallet.WInst.qrCodeImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Did.text = Wallet.WInst.did
    }
    
    @IBAction func SaveQRImg(_ sender: UIButton) {
        guard let qrImg:UIImage = Wallet.WInst.qrCodeImage else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(qrImg, nil, nil, nil)
        
        showToast(message: "保存成功")
    }
    
    @IBAction func CopyDid(_ sender: UIButton) {
        UIPasteboard.general.string = Wallet.WInst.did
        
        showToast(message: "复制成功")
    }
}
