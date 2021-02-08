//
//  HomeViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/3.
//

import UIKit

class HomeViewController: UIViewController {

//    @IBOutlet weak var AddressBarItem: UIBarButtonItem!
    @IBOutlet weak var HomeBackground: UIView!
    @IBOutlet weak var IDCardView: UIView!
//    @IBOutlet weak var ServiceView: UIView!
//    @IBOutlet weak var QRCodeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button =   UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:65, height:30)
        button.setImage(UIImage(named:"address_icon"), for: .normal)
        button.setTitle("北京", for: .normal)
//        AddressBarItem.customView = button
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
//
//        QRCodeView.layer.borderColor = UIColor.init(red: 12/255, green: 18/255, blue: 61/155, alpha: 1).cgColor
        
        HomeBackground.layer.addSublayer(setGradualChangColor(frame: HomeBackground.bounds))
        HomeBackground.layer.mask = configRectCorner(view: HomeBackground, corner: [.bottomLeft, .bottomRight] , radii: CGSize(width: 100, height: 100))
        
        IDCardView.layer.contents = UIImage(named: "bg")?.cgImage
//            UIColor(red: 245, green: 201, blue: 92, alpha: 1).cgColor
        
//        self.IDCardView.dropShadow()
//        self.ServiceView.dropShadow()
        
    }
    
    func setGradualChangColor(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.init(red: 245/255, green: 201/255, blue: 92/255, alpha: 1).cgColor, UIColor.init(red: 251/255, green: 230/255, blue: 149/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0,1]
        return gradientLayer
    }
    
    func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) -> CALayer {
            
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        
        return maskLayer
    }


}
//
//extension UIView {
//    func dropShadow(scale: Bool = true) {
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = .zero
//        layer.shadowRadius = 8
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//}
