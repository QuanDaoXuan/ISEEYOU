//
//  AuthService.swift
//  iseeyou
//
//  Created by resopt on 10/30/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

enum AuthService {
    case login(username: String, password: String)
    case register(username: String, password: String, confirmPassword: String)
    public func request() -> Observable<JSON> {
        var method: HTTPMethod {
            return .post
        }

        let params: Parameters? = {
            switch self {
            case .login(username: let username, password: let password):
                var param: [String: Any] = [:]
                param["username"] = username
                param["password"] = password
                return param

            case .register(username: let username, password: let password, confirmPassword: let confirmPassword):
                var param: [String: Any] = [:]
                param["username"] = username
                param["password"] = password
                return param
            }

        }()

        let path: String = {
            switch self {
            case .login:
                return "login/"
            case .register:
                return "register/"
            }

        }()

        return APIService.shareManager.callAPI(endpoint: APIUrl.url.rawValue, path: path, method: method, params: params, headers: APIService.returnHeaders())
    }
}
