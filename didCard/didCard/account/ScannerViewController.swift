//
//  ScannerViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/4/5.
//

import UIKit
import AVFoundation
import SwiftyJSON
import IosLib

class ScannerViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)

            captureSession.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }

        } catch {
            print(error)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    

    @IBAction func ImportPhotoButton(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = false
        present(vc, animated: true, completion: nil)
    }
    
    private func loginScanner(qrData: Data) {
        let json = JSON(qrData)
        
        if Wallet.WInst.isLocked {
            showInputDialog(title: "解锁账号",
                            message: Wallet.WInst.did!,
                            textPlaceholder: "请输入密码",
                            actionText: "确定",
                            cancelText: "取消",
                            cancelHandler: nil) { [self] (text: String?) in
                if Wallet.UnlockAcc(auth: text ?? "") {
                    login(json: json)
                } else {
                    let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    showAlert(title: "", message: "密码错误", okAction: action)
                }

            }
        } else {
            login(json: json)
        }
    }
    
    private func login(json: JSON) {
        if json["random_token"].exists() && json["auth_url"].exists() {
            let randToken = json["random_token"].string!
            let authUrl = json["auth_url"].string!

            let result:Bool = Utils.VerifyLogin(randToken, authUrl)

            if result {
                let action = UIAlertAction(title: "确定", style: .default) { (action) in
                    self.tabBarController?.selectedIndex = 0
                }
                self.showAlert(title: "", message: "登陆成功", okAction: action)
            } else {
                let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                self.showAlert(title: "", message: "登陆失败", okAction: action)
            }
        }
    }

}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if #available(iOS 13.0, *) {
            picker.navigationBar.barTintColor = .systemBackground
        }
        picker.dismiss(animated: true, completion: nil)
        let qrcodeImg = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as! UIImage
        
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let ciImage = CIImage(image: qrcodeImg)!
        
        let features = detector.features(in: ciImage)
        var codeStr = ""
        
        for feature in features as! [CIQRCodeFeature] {
            codeStr += feature.messageString!
        }
        
        if codeStr == "" {
            print("failed to phrase qrcode")
            return
        } else {
            print(codeStr)
            let codeObj:Data = codeStr.data(using: .utf8)!
            loginScanner(qrData: codeObj)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                print(String(metadataObj.stringValue!))
                let data: Data = ((metadataObj.stringValue!).data(using: .utf8))!
                loginScanner(qrData: data)
                 
            }
        }
    }

}

extension ScannerViewController {
    func showAlert(title: String, message: String, okAction: UIAlertAction){
        let successAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
//        let okAction = UIAlertAction(title: "确定", style: .default, handler: cancelHandler)
        successAlert.addAction(okAction)
        self.present(successAlert, animated: true, completion: nil)
    }
}

