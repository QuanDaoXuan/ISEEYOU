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
    var id = ""
    var username = ""
    var token = ""
    var image = ""

    init(json: JSON) {
        id = json["id"].stringValue
        username = json["username"].stringValue
        token = json["token"].stringValue
        image = json["image"].stringValue
    }
}
