//
//  ListUsersViewController.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ListUsersViewController: UITableViewController {
    let viewModel = ListUsersModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.getListUsers()
    }

    func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(R.nib.listUserCell)
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 100

        viewModel.datasource.bind(to: tableView.rx.items) { [unowned self]

            (_, index, value) -> UITableViewCell in

            let indexPath = IndexPath(row: index, section: 0)
            let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listUserCell, for: indexPath)!
            cell.setupCell(user: value)
            cell.contentView.rx.tapGesture().when(.recognized).subscribe(onNext: {
                _ in
                let vc = R.storyboard.prepare.prepareForCallViewController()!
                let model = PrepareForCallModel(user: value)
                vc.viewModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: cell.disposeBag)
            cell.selectionStyle = .none
            return cell

        }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.prepare.prepareForCallViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }
}
