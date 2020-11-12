//
//  TopProfileCell.swift
//  iseeyou
//
//  Created by resopt on 11/12/20.
//  Copyright © 2020 truc. All rights reserved.
//

import UIKit

class TopProfileCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var nameLb: UILabel!
    @IBOutlet var coverImageHeight: NSLayoutConstraint!
    @IBOutlet var addressLb: UILabel!

    @IBOutlet var idLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitView()
    }

    func setupInitView() {
        profileImageView.layer.cornerRadius = 75
//        coverImageView.layer.cornerRadius = 16
        profileImageView.image = R.image.profile_image_default()!
        coverImageView.image = R.image.cover_image_default()!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupProfile(user: User) {
        nameLb.text = user.username
        idLb.text = "id: " + user.idUsers

        if Int.random(in: 1 ... 190) % 2 == 0 {
            profileImageView.image = R.image.image_default_2()!
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.borderColor = UIColor.gray.cgColor
        } else {
            profileImageView.image = R.image.avatar1()!
        }
    }
}
