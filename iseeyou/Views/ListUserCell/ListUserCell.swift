//
//  ListUserCell.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import UIKit

class ListUserCell: UITableViewCell {
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var noteLb: UILabel!
    @IBOutlet var titleLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarView.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
