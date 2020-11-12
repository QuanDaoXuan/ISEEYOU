//
//  SaveDataDefaults.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import UIKit
class SaveDataDefaults {
    let defaults = UserDefaults.standard

    func setgetIsLogin(IsLogin: Bool) {
        defaults.set(IsLogin, forKey: "IsLogin")
    }

    func getIsLogin() -> Bool {
        return defaults.bool(forKey: "IsLogin")
    }

    func setToken(token: String) {
        defaults.set(token, forKey: "tokenId")
    }

    func getToken() -> String {
        return defaults.string(forKey: "tokenId") ?? ""
    }
}
