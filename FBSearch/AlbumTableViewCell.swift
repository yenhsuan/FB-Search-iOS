//
//  AlbumTableViewCell.swift
//  FBSearch
//
//  Created by Terry Chen on 4/14/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var FirstView: UIView!

    @IBOutlet weak var SecondView: UIView!
    
    
    @IBOutlet weak var AlbumTitle: UILabel!

    @IBOutlet weak var Pic1: UIImageView!
    @IBOutlet weak var Pic2: UIImageView!
    
    
    @IBOutlet weak var SecondHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var showDetails=false {
        didSet {
            SecondHeight.priority = showDetails ? 250:999
        }
    }

}
