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

    func setIsNeedLogin(isNeedLogin: Bool) {
        defaults.set(isNeedLogin, forKey: "isNeedLogin")
    }

    func getIsNeedLogin() -> Bool {
        return defaults.bool(forKey: "isNeedLogin")
    }

    func setToken(token: String) {
        defaults.set(token, forKey: "tokenId")
    }

    func getToken() -> String {
        return defaults.string(forKey: "tokenId") ?? ""
    }
}
