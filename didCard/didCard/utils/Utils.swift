//
//  Utils.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/3/1.
//

import UIKit

class Utils: NSObject {
    private override init() {
        super.init()
    }

    public func PostNoti(_ namedNoti: Notification) {
        NotificationCenter.default.post(namedNoti)
    }
    
}
