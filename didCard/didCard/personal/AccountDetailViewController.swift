//
//  AccountDetailViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/26.
//

import UIKit

class AccountDetailViewController: UIViewController {

    @IBOutlet weak var QRCodeImageView: UIImageView!
//    @IBOutlet weak var QRCodeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        QRCodeImageView.layer.borderWidth = 2
        QRCodeImageView.layer.borderColor = UIColor.init(red: 245/255, green: 201/255, blue: 92/255, alpha: 1).cgColor

        QRCodeImageView.image = Wallet.WInst.qrCodeImage
    }
    
    @IBAction func SaveQRImg(_ sender: UIButton) {
        guard let qrImg:UIImage = Wallet.WInst.qrCodeImage else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(qrImg, nil, nil, nil)
    }
    
    @IBAction func CopyDid(_ sender: UIButton) {
        UIPasteboard.general.string = Wallet.WInst.did
    }
}
