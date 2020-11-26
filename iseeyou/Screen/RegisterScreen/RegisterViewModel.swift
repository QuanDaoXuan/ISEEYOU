//
//  RegisterViewModel.swift
//  iseeyou
//
//  Created by resopt on 8/4/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterViewModel {
    var datasource = BehaviorRelay<[Int]>(value: [0, 1, 2, 3, 4, 5, 6, 7, 9])
    var user = User()
    var disposbag = DisposeBag()
    var registerRepository = AuthRepository()

    func setupRegister(user: User) {
        if user.username == "" || user.password == "" {
            DialogHelper.shared.showPopup(title: "Cảnh Báo", msg: "username và password không được để trống.")
        } else {
            registerRepository.register(user: self.user).subscribe(onNext: {
                _ in
                DialogHelper.shared.showPopup(title: "", msg: "Đăng ký thành công.!")
            }, onError: {
                _ in
                DialogHelper.shared.showPopup(title: "", msg: "Có lỗi xảy ra khi đăng ký, vui lòng kiểm tra lại.")
            }).disposed(by: disposbag)
        }
    }
}
