//
//  User.swift
//  iseeyou
//
//  Created by resopt on 11/16/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import SwiftyJSON

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
