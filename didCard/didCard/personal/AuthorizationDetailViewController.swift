//
//  AuthorizationDetailViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/4/12.
//

import UIKit

class AuthorizationDetailViewController: UIViewController {
    
    @IBOutlet weak var host: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var showHideBtn: UIButton!
    var accDetail:CDAccounts?
    var isShow = false
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        if let data = accDetail {
            host.text = data.website
            username.text = data.account
            password.text = "***"
            if isShow {
                password.text = data.password
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHostListSegue" {
            if let view = segue.destination as? AccessableListController {
                view.returnHost = {[weak self] res in
                    self?.host.text = res
                }
            }
        }
        
    }
    @IBAction func showOrHide(_ sender: UIButton) {
        if self.isShow {
            self.isShow = false
            self.password.text = "***"
            self.showHideBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        } else {
            self.isShow = true
            self.password.text = accDetail?.password
            self.showHideBtn.setImage(UIImage(named: "open_icon"), for: .normal)
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if host.text != nil && username.text != nil && password.text != nil {
            Host.addUpdateHost(host: host.text!, username: username.text!, password: password.text!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        if host.text != nil && username.text != nil && password.text != nil {
            Host.delHost(host: host.text!, username: username.text!, password: password.text!)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
