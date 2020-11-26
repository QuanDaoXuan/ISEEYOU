//
//  ProfileViewModel.swift
//  iseeyou
//
//  Created by resopt on 11/12/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class ProfileViewModel {
    var authRepository = AuthRepository()
    var user = User()
    var disposeBag = DisposeBag()
    var datasource = BehaviorRelay<[Int]>(value: [0, 1, 2, 4, 5])
    init() {
//        authMe()
    }

    func authMe(viewController: UIViewController) {
        authRepository.auth_me().subscribe(onNext: {
            json in
            self.user = User(json: json)
            self.datasource.accept(self.datasource.value)
        }, onError: {
            error in
            print(error)
            self.user = User()
            self.datasource.accept(self.datasource.value)
        }).disposed(by: disposeBag)
    }
}
