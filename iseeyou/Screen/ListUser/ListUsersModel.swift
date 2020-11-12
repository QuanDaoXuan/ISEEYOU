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

    init() {}
}
