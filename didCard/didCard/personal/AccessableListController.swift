//
//  AccessableListController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/4/12.
//

import UIKit
import SwiftyJSON

typealias selectHost = (String) -> Void

class AccessableListController: UITableViewController {
    
    var webList:JSON = []
    
    var returnHost: selectHost!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            Utils.getAccessableList { res in
                print("host list:\(String(describing: res))")
                self.webList = res!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.webList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "canUsedIdentifierID", for: indexPath)
        
        if let c = cell as? BaseTableViewCell {
            let obj = self.webList[indexPath.row]
            c.initWith(obj.string!)
            
            
            c.selectionStyle = .none

            return c
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BaseTableViewCell else {
            return
        }
        cell.updateCheck(false)
        let text = cell.Website.text!
        
        self.returnHost(text)
        self.navigationController?.popViewController(animated: true)
    }

}

extension AccessableListController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        self.tableView.reloadData()
    }
}
