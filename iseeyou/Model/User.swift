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
    var password = ""
    var name = ""
    var sdt = ""
    var imageLink = ""
    var address = ""

    init(json: JSON) {
        idUsers = json["user"]["idUsers"].stringValue
        username = json["user"]["username"].stringValue
        token = json["user"]["idUsers"].stringValue
        name = json["user"]["name"].stringValue
        sdt = json["user"]["sdt"].stringValue
        imageLink = json["user"]["imageLink"].stringValue
        address = json["user"]["address"].stringValue
    }

    init(listUser: JSON) {
        idUsers = listUser["idUsers"].stringValue
        username = listUser["username"].stringValue
        token = listUser["idUsers"].stringValue
        name = listUser["name"].stringValue
        sdt = listUser["sdt"].stringValue
        imageLink = listUser"imageLink"].stringValue
        address = listUser["address"].stringValue
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
