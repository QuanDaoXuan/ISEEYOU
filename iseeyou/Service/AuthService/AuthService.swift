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
    case register(user: User)
    case auth_me
    case get_list_users
    public func request() -> Observable<JSON> {
        var method: HTTPMethod {
            switch self {
            case .get_list_users:
                return .get
            default:
                return .post
            }
        }

        let params: Parameters? = {
            switch self {
            case .login(username: let username, password: let password):
                var param: [String: Any] = [:]
                param["username"] = username
                param["password"] = password
                return param

            case .register(let user):
                var param: [String: Any] = [:]
                param["username"] = user.username
                param["password"] = user.password
                param["name"] = user.name
                param["address"] = user.address
                param["name"] = user.name
                param["imageLink"] = user.imageLink
                param["sdt"] = user.sdt
                return param
            case .auth_me:
                var param: [String: Any] = [:]
                param["idUsers"] = SaveDataDefaults().getToken()

                return param
            case .get_list_users:

                return nil
            }

        }()

        let path: String = {
            switch self {
            case .login:
                return "login/"
            case .register:
                return "register/"
            case .auth_me:
                return "auth_me/"
            case .get_list_users:
                return "get_list_users/"
            }

        }()

        return APIService.shareManager.callAPI(endpoint: APIUrl.url.rawValue, path: path, method: method, params: params, headers: APIService.returnHeaders())
    }
}
