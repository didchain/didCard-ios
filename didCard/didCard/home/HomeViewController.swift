//
//  HomeViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/3.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var AddressBarItem: UIBarButtonItem!
    @IBOutlet weak var IDCardView: UIView!
    @IBOutlet weak var ServiceView: UIView!
    @IBOutlet weak var QRCodeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button =   UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:65, height:30)
        button.setImage(UIImage(named:"address_icon"), for: .normal)
        button.setTitle("北京", for: .normal)
        AddressBarItem.customView = button
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        QRCodeView.layer.borderColor = UIColor.init(red: 12/255, green: 18/255, blue: 61/155, alpha: 1).cgColor

//            UIColor(red: 245, green: 201, blue: 92, alpha: 1).cgColor
        
//        self.IDCardView.dropShadow()
//        self.ServiceView.dropShadow()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
