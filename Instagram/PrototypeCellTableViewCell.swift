//
//  PrototypeCellTableViewCell.swift
//  Instagram
//
//  Created by Shivam Bharuka on 1/28/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class PrototypeCellTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var adminImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var captionName: UILabel!
    @IBOutlet weak var captionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
