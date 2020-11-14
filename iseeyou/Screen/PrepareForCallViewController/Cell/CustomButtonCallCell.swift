//
//  CustomButtonCallCell.swift
//  iseeyou
//
//  Created by resopt on 11/12/20.
//  Copyright © 2020 truc. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CustomButtonCallCell: UITableViewCell {
    @IBOutlet var audioCallBtn: UIButton!
    var disposeBag = DisposeBag()
    @IBOutlet var videoCallBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        audioCallBtn.layer.cornerRadius = 25
        videoCallBtn.layer.cornerRadius = 25
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
