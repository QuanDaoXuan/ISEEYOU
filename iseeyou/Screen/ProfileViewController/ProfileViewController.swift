//
//  ProfileViewController.swift
//  iseeyou
//
//  Created by resopt on 11/12/20.
//  Copyright © 2020 truc. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var viewModel = LoginViewModel()
    var loginReposytory = AuthRepository()
    var disposbag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setInitScreen()
    }

    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(R.nib.topProfileCell)
        tableView.register(R.nib.labelWithArrowCel)

        tableView.estimatedRowHeight = 250

        viewModel.datasource.bind(to: tableView.rx.items) { [unowned self]

            (_, index, value) -> UITableViewCell in
            switch value {
                case 0:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topProfileCell, for: indexPath)!
                    cell.selectionStyle = .none
                    return cell
                case 1:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.labelWithArrowCel, for: indexPath)!
                    cell.selectionStyle = .none
                    cell.contentView.rx.tapGesture().when(.recognized).subscribe(onNext: {
                        _ in
                        SaveDataDefaults().setgetIsLogin(IsLogin: false)
                        let vc = R.storyboard.main.loginscreen()!
                        self.navigationController?.setViewControllers([vc], animated: true)
                        self.removeFromParent()
                    }).disposed(by: cell.disposeBag)
                    return cell
                default:
                    let cell = UITableViewCell()
                    return cell
            }
        }.disposed(by: disposbag)
    }

    func setInitScreen() {
        navigationController?.title = "You"
        navigationItem.title = "You"
        title = "Your title"
    }

    override func viewWillAppear(_ animated: Bool) {
//        setInitScreen()
    }
}
