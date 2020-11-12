//
//  ListUserCell.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import RxSwift
import UIKit
class ListUserCell: UITableViewCell {
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var noteLb: UILabel!
    @IBOutlet var titleLb: UILabel!
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarView.layer.cornerRadius = 30
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(user: User) {
        titleLb.text = user.username

        if Int.random(in: 1 ... 190) % 2 == 0 {
            avatarView.image = R.image.image_default_2()!
            avatarView.layer.borderWidth = 1
            avatarView.layer.borderColor = UIColor.gray.cgColor
        } else {
            avatarView.image = R.image.avatar1()!
        }
    }
}
