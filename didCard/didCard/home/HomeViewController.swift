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
    
        print("XXxXXXX")
        
        print("\(HomeBackground.bounds.size.width)")
        print("\(HomeBackground.bounds.size.height)")
        IDCardView.layer.contents = UIImage(named: "bg")?.cgImage
        
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
            
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
//        maskLayer.bounds.size.width = UIScreen.main.bounds.width
//        maskLayer.bounds.size.height = view.bounds.size.height
        maskLayer.path = maskPath.cgPath
        print("masklayer")
        print("\(maskLayer.bounds.size.width)")
        print("\(maskLayer.bounds.size.height)")
    
        print("\(UIScreen.main.bounds.size.width)")
        return maskLayer
        
    }
    
//    open func setCornerRadius(radius:CGFloat){
//        let shapeLayer = CAShapeLayer.init()
//        shapeLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius).cgPath
//        self.layer.mask = shapeLayer
//    }


}

