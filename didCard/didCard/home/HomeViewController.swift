//
//  HomeViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/3.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var HomeBackground: UIView!
    @IBOutlet weak var IDCardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        HomeBackground.layer.insertSublayer(setGradualChangColor(frame: HomeBackground.bounds), at: 0)
        HomeBackground.layer.mask = configRectCorner(view: HomeBackground, corner: [.bottomLeft, .bottomRight] , radii: CGSize(width: 100, height: 100))
    
        IDCardView.layer.contents = UIImage(named: "bg")?.cgImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("账号有没有")
        print(String(Wallet.WInst.hasAccount))
        print(String(Wallet.WInst.did ?? "没有"))
        if !Wallet.WInst.hasAccount {
            self.showCreateDialog()
            return
        }
    }
    
    func showCreateDialog(){
        self.performSegue(withIdentifier: "CreateAccountSegID", sender: self)
    }

    
    @IBAction func UnlockQRCodeBtn(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "UnlockSeg", sender: self)
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

}

