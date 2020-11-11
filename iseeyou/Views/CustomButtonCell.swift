//
//  CustomButtonCell.swift
//  iseeyou
//
//  Created by resopt on 8/4/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import RxSwift
import UIKit

class CustomButtonCell: UITableViewCell {
    @IBOutlet var marginBottom: NSLayoutConstraint!
    @IBOutlet var marginTop: NSLayoutConstraint!
    @IBOutlet var button: UIButton!
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        marginBottom.constant = 10
        marginTop.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupButton(title: String) {
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 25
    }
}
