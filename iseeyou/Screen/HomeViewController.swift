//
//  HomeViewController.swift
//  iseeyou
//
//  Created by resopt on 7/27/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import Rswift
import RxCocoa
import RxSwift
import UIKit
class HomeViewController: UIViewController {
    @IBOutlet var favoriteItem: UITabBarItem!
    @IBOutlet var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
    }
}
