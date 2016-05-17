//
//  NewDiveViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/16/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import Eureka
class NewDiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLoginForm(toForm: form)
    }
    
    private func addLoginForm(toForm form: Form) {
        form +++ Section("Login Form")
            <<< TextRow() { $0.placeholder = "Username" }
            <<< PasswordRow() { $0.placeholder = "Password" }
            <<< ButtonRow() {
                $0.title = "Login"
                $0.onCellSelection { cell, row in
                    self.presentAlert(message: "Will login")
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
