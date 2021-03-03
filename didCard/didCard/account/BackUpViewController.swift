//
//  BackUpViewController.swift
//  didCard
//
//  Created by wesley on 2021/2/2.
//

import UIKit

class BackUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func BackToHome(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func SaveQRCode(_ sender: UIButton) {
        guard let qrImg:UIImage = Wallet.WInst.qrCodeImage else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(qrImg, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
}
