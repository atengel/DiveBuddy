//
//  PhotoTableViewCell.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/28/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    //collection view for photos
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //set the collection view delegate so we have control over our collection view
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
