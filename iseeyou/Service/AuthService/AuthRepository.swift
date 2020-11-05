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
    func register(username: String, password: String, confirmPassword: String) -> Observable<JSON>
}

struct AuthRepository: AuthProtocol {
    func login(username: String, password: String) -> Observable<JSON> {
        return AuthService.login(username: username, password: password).request()
    }

    func register(username: String, password: String, confirmPassword: String) -> Observable<JSON> {
        return AuthService.register(username: username, password: password, confirmPassword: confirmPassword).request()
    }
}
