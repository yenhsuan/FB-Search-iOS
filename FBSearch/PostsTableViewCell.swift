//
//  PostsTableViewCell.swift
//  FBSearch
//
//  Created by Terry Chen on 4/15/17.
//  Copyright © 2017 Terry Chen. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var Pic: UIImageView!
    @IBOutlet weak var PostMsg: UITextView!
    @IBOutlet weak var Time: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
