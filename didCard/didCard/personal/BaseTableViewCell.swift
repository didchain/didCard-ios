//
//  BaseTableViewCell.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/4/12.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var Website: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCheck(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func initWith(_ labelStr: String) {
        self.Website.text = labelStr
    }
    
    public func updateCheck(_ check:Bool) {
        checkImg.isHidden = check
    }

}
