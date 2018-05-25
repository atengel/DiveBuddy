//
//  DiveTableViewCell.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/27/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit

class DiveTableViewCell: UITableViewCell {
    
    //first image of dive
    @IBOutlet weak var diveImageView: UIImageView!
    //label for dive location
    @IBOutlet weak var diveDescriptionLabel: UILabel!
    //label for dive date
    @IBOutlet weak var diveDateLabel: UILabel!
    //label for dive site
    @IBOutlet weak var diveSiteLabel: UILabel!
    //dive associated with the table view cell 
    var dive: DiveInfo?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
