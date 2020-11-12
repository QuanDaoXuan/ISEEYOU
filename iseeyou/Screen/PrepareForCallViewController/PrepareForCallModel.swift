//
//  PrepareForCallModel.swift
//  iseeyou
//
//  Created by resopt on 11/12/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class PrepareForCallModel {
    var user: User!

    var datasource = BehaviorRelay<[Int]>(value: [0, 1])
    var disposbag = DisposeBag()

    init(user: User) {
        self.user = user
    }
}
