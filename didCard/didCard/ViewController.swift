//
//  ViewController.swift
//  didCard
//
//  Created by wesley on 2021/1/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-70, y: self.view.frame.height/2 - 20, width: 140, height: 50))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textColor = UIColor.white
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0) {
            toastLabel.alpha = 0.0
        } completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
}
