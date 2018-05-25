//
//  InspectImageViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 6/5/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit


//class used to inspect(zoom and scroll) an image
class InspectImageViewController: UIViewController, UIScrollViewDelegate {
    
    //image view for inspection
    private var imageView = UIImageView()
    
    //image to scroll
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.sizeToFit()
            updateUI()
        }
    }
    
    //set our default and minimum zoom scale to perfectly frame the entire image
    private func updateUI() {
        imageScrollView?.minimumZoomScale = 0.1
        imageScrollView?.zoomScale = view.frame.width / image!.size.width
    }
    
    //programmatically place image view inside our scroll view
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.addSubview(imageView)
        updateUI()
    }
    
    //set up scroll view
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.delegate = self
            imageScrollView.maximumZoomScale = 4
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to make imageview zoom instead of the scrollview
    func viewForZoomingInScrollView(sender: UIScrollView) -> UIView? {
        return imageView
    }
    
    
}