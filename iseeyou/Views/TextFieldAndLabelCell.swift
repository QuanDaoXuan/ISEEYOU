//
//  TextFieldAndLabelCell.swift
//  iseeyou
//
//  Created by resopt on 8/4/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TextFieldAndLabelCell: UITableViewCell {
    @IBOutlet var titleLb: UILabel!
    @IBOutlet var textField: UITextField!
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(title: String, placeHoder: String?) {
        titleLb.text = title
        textField.placeholder = placeHoder ?? ""
    }

    func bindTextField(viewModel: RegisterViewModel, type: Int) {
        switch type {
        case 1:
            textField.rx.text.bind { value in
                print(viewModel.usermame)
                viewModel.usermame = value ?? ""
                print(viewModel.usermame)
            }.disposed(by: disposeBag)
        case 2:
            textField.rx.text.bind { value in
                viewModel.password = value ?? ""
                print(viewModel.password)
            }.disposed(by: disposeBag)
        case 3:
            textField.rx.text.bind { value in
                viewModel.confirmPassword = value ?? ""
            }.disposed(by: disposeBag)
        default:
            break
        }
    }
}
