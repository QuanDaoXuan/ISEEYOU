//
//  RegisterViewModel.swift
//  iseeyou
//
//  Created by resopt on 8/4/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterViewModel {
    var datasource = BehaviorRelay<[Int]>(value: [0, 1, 2, 3, 4, 5])
    var usermame = ""
    var password = ""
    var confirmPassword = ""
}
