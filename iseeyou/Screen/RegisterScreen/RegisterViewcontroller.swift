//
//  ViewController.swift
//  iseeyou
//
//  Created by resopt on 7/24/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import Rswift
import RxCocoa
import RxSwift
import UIKit

class RegisterViewcontroller: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel = RegisterViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        navigationController?.navigationBar.isHidden = false
    }

    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(R.nib.textFieldAndLabelCell)
        tableView.register(R.nib.topRegisterCell)
        tableView.register(R.nib.customButtonCell)
        tableView.estimatedRowHeight = 50

        viewModel.datasource.bind(to: tableView.rx.items) { [unowned self]
            (_, index, value) -> UITableViewCell in
            switch value {
            case 1:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                cell.setupCell(title: "Nhập user name", placeHoder: "enter your user name")
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            case 2:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                cell.setupCell(title: "Nhập password", placeHoder: "enter your password")
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            case 3:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                cell.setupCell(title: "Nhập lại password", placeHoder: "enter your password again")
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            case 0:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topRegisterCell, for: indexPath)!
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            case 5:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customButtonCell, for: indexPath)!
                cell.setupButton(title: "Register Now")
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        }.disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] _ in
            //
        }).disposed(by: disposeBag)
    }
}
