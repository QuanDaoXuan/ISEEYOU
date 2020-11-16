//
//  ListUsersModel.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON
class ListUsersModel {
    var authRepository = AuthRepository()
    var disposeBag = DisposeBag()
    var datasource = BehaviorRelay<[User]>(value: [])
    var user = User()
    
    init() {
        authMe()
    }

    func getListUsers() {
        authRepository.get_list_users().subscribe(onNext: {
            json in
            let usersJson = json["users"].arrayValue
            self.datasource.accept(User().getListUser(json: usersJson))
        }, onError: { error in
            print(error)
            self.datasource.accept([])
        }).disposed(by: disposeBag)
    }

    func authMe() {
        authRepository.auth_me().subscribe(onNext: {
            json in
            self.user = User(json: json)
            self.datasource.accept(self.datasource.value)
        }, onError: {
            _ in
            print("Cant call Auth_me")
        }).disposed(by: disposeBag)
    }
}


