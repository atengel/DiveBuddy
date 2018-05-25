//
//  SharingViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 6/2/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import Social
class SharingViewController: UIViewController {
    
    private var alertController = UIAlertController(title: "", message: "Share your dive", preferredStyle: UIAlertControllerStyle.ActionSheet)
    @IBAction func showSharingOptions(sender: UIBarButtonItem) {
       }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var sharingTextView: UITextView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        configureSharingTextView()
        // Do any additional setup after loading the view.
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
