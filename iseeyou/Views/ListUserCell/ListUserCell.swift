//
//  ListUserCell.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Kingfisher
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
        noteLb.text = user.address
        if user.imageLink == "" {
            avatarView.image = R.image.image_default_2()!
        } else {
            let url = URL(string: user.imageLink)
            avatarView.kf.setImage(with: url)
        }
    }
}
