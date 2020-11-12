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
    var user: [User] = []
    var authRepository = AuthRepository()
    var disposeBag = DisposeBag()
    var datasource = BehaviorRelay<[User]>(value: [])

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
}

class User {
    var idUsers = ""
    var username = ""
    var token = ""
    var image = ""

    init(json: JSON) {
        idUsers = json["user"]["idUsers"].stringValue
        username = json["user"]["username"].stringValue
        token = json["user"]["idUsers"].stringValue
    }

    init(listUser: JSON) {
        idUsers = listUser["idUsers"].stringValue
        username = listUser["username"].stringValue
        token = listUser["idUsers"].stringValue
    }

    func getListUser(json: [JSON]) -> [User] {
        var users: [User] = []
        for item in json {
            let user = User(listUser: item)
            print(user.idUsers)
            users.append(user)
        }
        return users
    }

    init() {}
}
