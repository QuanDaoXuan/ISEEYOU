//
//  AuthRepository.swift
//  iseeyou
//
//  Created by resopt on 10/30/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

protocol AuthProtocol {
    func login(username: String, password: String) -> Observable<JSON>
    func register(user: User) -> Observable<JSON>
    func auth_me() -> Observable<JSON>
    func get_list_users() -> Observable<JSON>
}

struct AuthRepository: AuthProtocol {
    func get_list_users() -> Observable<JSON> {
        return AuthService.get_list_users.request()
    }

    func auth_me() -> Observable<JSON> {
        return AuthService.auth_me.request()
    }

    func login(username: String, password: String) -> Observable<JSON> {
        return AuthService.login(username: username, password: password).request()
    }

    func register(user: User) -> Observable<JSON> {
        return AuthService.register(user: user).request()
    }
}
