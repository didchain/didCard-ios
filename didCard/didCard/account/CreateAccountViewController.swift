//
//  CreateAccountViewController.swift
//  didCard
//
//  Created by wesley on 2021/2/2.
//

import UIKit

class CreateAccountViewController: UIViewController {

        @IBOutlet weak var PassWrod2FD: UITextField!
        @IBOutlet weak var PassWrod1FD: UITextField!
        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

        @IBAction func CreateAccount(_ sender: UIButton) {
                
                //TODO::
                //lib create account
                //result
                
                self.performSegue(withIdentifier: "CreateSuccessSeg", sender: self)
        }
        
        
}
