//
//  UserTableViewCell.swift
//  FBSearch
//
//  Created by Terry Chen on 4/13/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var favicon: UIImageView!
        @IBOutlet weak var ImgIcon: UIImageView!
    @IBOutlet weak var LabelName: UILabel!
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
