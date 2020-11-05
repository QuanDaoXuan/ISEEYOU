//
//  TopRegisterCell.swift
//  iseeyou
//
//  Created by resopt on 8/4/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import UIKit

class TopRegisterCell: UITableViewCell {
    @IBOutlet var buttonView: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonView.layer.cornerRadius = 60
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
