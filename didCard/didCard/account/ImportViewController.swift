//
//  ImportViewController.swift
//  didCard
//
//  Created by wesley on 2021/2/2.
//

import UIKit
import AVFoundation
import SwiftyJSON

class ImportViewController: UIViewController {
    
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
    
    @IBAction func ImportPhotoButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = false
        present(vc, animated: true, completion: nil)
    }
    
    private func importAccountData(codeStr: String) {
        let qrData: Data = ((codeStr).data(using: .utf8))!
        let json = JSON(qrData)
        if json["did"].exists() {
            showInputDialog(title: "验证密码",
                            message: json["did"].string!,
                            textPlaceholder: "请输入密码",
                            actionText: "确定",
                            cancelText:  "取消",
                            cancelHandler: nil) { (text: String?) in
                if Wallet.ImportAcc(auth: text!, json: codeStr) == true {
                    print("导入成功")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension ImportViewController: AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
        
        importAccountData(codeStr: codeStr)
        
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
            
            let metadataStr = metadataObj.stringValue!
            importAccountData(codeStr: metadataStr)
        }
    }
    
    

}

extension UIViewController {
    func showInputDialog(title: String,
                         message: String,
                         textPlaceholder: String,
                         actionText: String,
                         cancelText: String,
                         cancelHandler: ((UIAlertAction) -> Void)?,
                         actionHandler: ((_ text: String?) -> Void)?
                         ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = textPlaceholder
        }
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: cancelHandler))
        alert.addAction(UIAlertAction(title: actionText, style: .destructive, handler: { (action: UIAlertAction) in
            guard let textField = alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
