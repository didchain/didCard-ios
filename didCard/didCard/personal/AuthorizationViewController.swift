//
//  AuthorizationViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/4/11.
//

import UIKit

class AuthorizationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var accountDatas:[CDAccounts] = []

//    var currentData:CDAccounts?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 148
        tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.accountDatas = Host.getHostList()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit", let vc = segue.destination as? AuthorizationDetailViewController {

            if let btn = sender as? UIButton,
               let cell = btn.superview?.superview?.superview as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell) {
                vc.accDetail = accountDatas[indexPath.row]
            }
            
            
        }
    }

}
extension AuthorizationViewController: SelectionChangeDelegate {
    func didchanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CDAccountsID", for: indexPath)
        
        if let c = cell as? AuthorizationTableViewCell {
            let obj = self.accountDatas[indexPath.row]
            c.data = obj
            c.delegate = self
            c.populate(obj, idx: indexPath.row)
            return c
        }
        return cell
    }
    
}
