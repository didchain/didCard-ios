//
//  AuthorizationTableViewCell.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/4/12.
//

import UIKit
protocol SelectionChangeDelegate {
    func didchanged()
}
class AuthorizationTableViewCell: UITableViewCell {
    
    var data:CDAccounts?
    var delegate:SelectionChangeDelegate?
    var checked = false
    
    let width:CGFloat = UIScreen.main.bounds.width
    
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var IsUsedBtn: UIButton!
    
    
    @IBAction func isUsedButton(_ sender: UIButton) {
        update()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

    }

    public func populate(_ account: CDAccounts, idx: Int) {
        let web_site = account.website
        let acc = account.account
//        let pass_word = account.password
        checked = account.isUsed

        websiteLabel.text = web_site
        usernameLabel.text = acc
//        passwordLabel.text = pass_word
        
        isUsedImg(checked)
    }
    
    func isUsedImg(_ isUsed: Bool) {
        if isUsed {
            self.IsUsedBtn.setImage(UIImage(named: "checked_icon"), for: .normal)

        } else {
            self.IsUsedBtn.setImage(UIImage(named: "Unchecked_icon"), for: .normal)
        }
    }
    
    func update() {
        if let data = data {
            if data.isUsed {
                Host.cancelUsed(data)
                checked = false
                isUsedImg(false)
            } else {
                Host.setUsed(data, force: true)
                checked = true
                isUsedImg(true)
            }
        }
        
        self.delegate?.didchanged()
    }
    

}
