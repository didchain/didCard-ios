//
//  ImportViewController.swift
//  didCard
//
//  Created by wesley on 2021/2/2.
//

import UIKit
import AVFoundation

class ImportViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
//    @IBOutlet var messageLabel: UILabel!
//    @IBOutlet var topBar: UIView!
    
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
            //captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)

            captureSession.startRunning()
            
            // Move the message label and top bar to the front
//            view.bringSubviewToFront(messageLabel)
//            view.bringSubviewToFront(topBar)
            
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
    
    @IBAction func ImportPhotoButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = false
        present(vc, animated: true, completion: nil)

    }
    
}

extension ImportViewController: AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("\(info)")
        
//        guard let qrcodeImg = info[.originalImage] as? UIImage else {
//            return
//        }
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
                let alert = UIAlertController(title: "QR Code", message: metadataObj.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "重新扫描", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
//                messageLabel.text = metadataObj.stringValue
                print(metadataObj.stringValue!)
            }
        }
    }

}
