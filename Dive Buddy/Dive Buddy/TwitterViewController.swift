//
//  TwitterViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 6/2/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import Social
class TwitterViewController: UIViewController {

    @IBOutlet weak var sharingTextView: UITextView!

    func configureSharingTextView() {
        sharingTextView.layer.cornerRadius = 8.0
        sharingTextView.layer.borderColor = UIColor(white: 0.75, alpha: 0.5).CGColor
        sharingTextView.layer.borderWidth = 1.2
    }
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
