//
//  HomeViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/3.
//
import Foundation
import UIKit
import LocalAuthentication
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var TintText: UILabel!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var HomeBackground: UIView!
    @IBOutlet weak var IDCardView: UIView!
    @IBOutlet weak var QRButton: UIButton!
    @IBOutlet weak var ClickToUnlock: UILabel!
    @IBOutlet weak var ServiceView: UIView!
    @IBOutlet weak var DidString: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let scrollview = UIScrollView(frame: self.view.bounds)
//
//        scrollview.isScrollEnabled = true
//        scrollview.bounces = true
//        scrollview.showsVerticalScrollIndicator = false
//        scrollview.showsHorizontalScrollIndicator = false
//        
//        scrollview.addSubview(ContentView)
//        
//        self.view.addSubview(scrollview)
        
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        HomeBackground.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: HomeBackground.bounds.height)
        HomeBackground.layer.insertSublayer(setGradualChangColor(frame: HomeBackground.bounds), at: 0)
        HomeBackground.layer.mask = configRectCorner(view: HomeBackground, corner: [.bottomLeft, .bottomRight] , radii: CGSize(width: 100, height: 100))
        IDCardView.layer.contents = UIImage(named: "bg")?.cgImage
       
        NotificationCenter.default.addObserver(self, selector: #selector(setDidName(_:)), name: NSNotification.Name(rawValue: "ACCOUNT_CREATED"), object: nil)
        DidString.text = Wallet.WInst.did
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Wallet.WInst.did == nil {
            self.showCreateDialog()
            return
        }
        
//        if CLLocationManager.authorizationStatus() == .denied {
            //        locationManager.requestWhenInUseAuthorization()
            //        locationManager.requestAlwaysAuthorization()
//            let locationAlert = UIAlertController(title: "没有定位权限", message: "请打开定位权限", preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
//            locationAlert.addAction(okAction)
//            self.present(locationAlert, animated: true, completion: nil)
//        }
        
        if Setting.getWithoutAuth() {
            if !Wallet.UnlockAcc(auth: nil) {
                print("免密解锁失败")
                return
            }
        }
        
        if Wallet.WInst.isLocked == false {
            self.QRButton.setBackgroundImage(Wallet.WInst.qrCodeSignImage, for: .normal)
            self.ClickToUnlock.isHidden = true
            self.TintText.text = "💫点击二维码刷新"
        }


    }
    
    @objc func setDidName(_ notification: Notification?){
        DispatchQueue.main.async {
//            NSLog("======>\(Wallet.WInst.walletJSON ?? "-----")")
            self.DidString.text = Wallet.WInst.did
            if Wallet.WInst.isLocked == false {
                self.reloadWalletData()
            }
        }
    }
    
    func showCreateDialog(){
        self.performSegue(withIdentifier: "CreateAccountSegID", sender: self)
    }

    func reloadWalletData() {
        self.QRButton.setBackgroundImage(Wallet.WInst.qrCodeSignImage, for: .normal)
        self.ClickToUnlock.isHidden = true
        self.TintText.text = "💫点击二维码刷新"
    }
    
    @IBAction func UnlockQRCodeBtn(_ sender: UIButton) {
        if Wallet.WInst.isLocked == true {
            if Setting.getUseFaceID() {
                let context = LAContext()
                var error: NSError?
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "是否允许App使用您的\(context.biometryType)"
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self](success, authError) in
                        DispatchQueue.main.async {
                            if success {
                                if Wallet.UnlockAcc(auth: nil) {
                                    self?.reloadWalletData()
                                }
                            } else {
                                let ac = UIAlertController(title: "验证失败", message: "请重试", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "使用密码", style: .default, handler: { (_:UIAlertAction) in
                                    self?.performSegue(withIdentifier: "ShowPasswordSIG", sender: self)
                                }))
                                ac.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                                self?.present(ac, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    let ac = UIAlertController(title: "设备不支持", message: "您的设备不支持FaceID/TouchID", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "ShowPasswordSIG", sender: self)
                }
            } else {
                self.performSegue(withIdentifier: "ShowPasswordSIG", sender: self)
            }
        }
    }
    
    func setGradualChangColor(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.colors = [UIColor.init(red: 245/255, green: 201/255, blue: 92/255, alpha: 1).cgColor, UIColor.init(red: 251/255, green: 230/255, blue: 149/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0.0,1.0]

        return gradientLayer
    }
    
    func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) -> CALayer {
        var bouns_s = view.bounds
        bouns_s.size.width = self.view.bounds.size.width
        
        let maskPath = UIBezierPath.init(roundedRect: bouns_s, byRoundingCorners: corner, cornerRadii: radii)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bouns_s
        maskLayer.path = maskPath.cgPath
        
        return maskLayer
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPasswordSIG"{
            let vc = segue.destination as! QRCodeViewController
            
            vc.delegate = {
                DispatchQueue.main.async {
                    self.reloadWalletData()
                }
            }
        }
    
    }
}
