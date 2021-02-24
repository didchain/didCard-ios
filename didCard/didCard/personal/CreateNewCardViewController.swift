//
//  CreateNewCardViewController.swift
//  didCard
//
//  Created by 郭晓芙 on 2021/2/4.
//

import UIKit

class CreateNewCardViewController: UIViewController {

    @IBOutlet weak var PassWrod1FD: UITextField!
    @IBOutlet weak var PassWrod2FD: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func CreateAccount(_ sender: UIButton) {
        if PassWrod1FD.text != PassWrod2FD.text {
            print("两次输入密码不同")
            return
        }
        
        guard let password = PassWrod1FD.text, password != "" else {
            return
        }
        
//        if false == Wallet.NewAcc(auth: password){
//            return
//        }

//        self.performSegue(withIdentifier: "CreateSuccessSeg", sender: self)
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
