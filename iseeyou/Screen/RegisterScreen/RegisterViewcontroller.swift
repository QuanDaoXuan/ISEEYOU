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

enum RegisterType {
    case userName
    case password
    case address
    case name
    case phoneNumber
    case imageLink
}

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
        tableView.estimatedRowHeight = 90

        viewModel.datasource.bind(to: tableView.rx.items) { [unowned self]
            (_, index, value) -> UITableViewCell in
            switch value {
                case 0:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topRegisterCell, for: indexPath)!
                    cell.selectionStyle = .none
                    return cell
                case 1:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                    cell.setupCell(title: "Nhập user name ", placeHoder: "enter your user name")
                    cell.bindTextField(viewModel: self.viewModel, type: .userName)
                    cell.selectionStyle = .none
                    return cell
                case 2:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                    cell.setupCell(title: "Nhập password ", placeHoder: "enter your password")
                    cell.bindTextField(viewModel: self.viewModel, type: .password)
                    cell.selectionStyle = .none
                    return cell
                case 3:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                    cell.setupCell(title: "nhập tên", placeHoder: "Nhập tên thường gọi của bạn")
                    cell.bindTextField(viewModel: self.viewModel, type: .name)
                    cell.selectionStyle = .none
                    return cell
                case 4:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                    cell.setupCell(title: "Nhập địa chỉ", placeHoder: "Nhập địa chỉ của bạn")
                    cell.bindTextField(viewModel: self.viewModel, type: .address)
                    cell.selectionStyle = .none
                    return cell
                case 5:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                    cell.setupCell(title: "Nhập sdt", placeHoder: "Nhập SDT của bạn")
                    cell.bindTextField(viewModel: self.viewModel, type: .phoneNumber)
                    cell.selectionStyle = .none
                    return cell
                case 6:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                    cell.setupCell(title: "Nhập link ảnh đại diện", placeHoder: "Link ảnh đại diện")
                    cell.bindTextField(viewModel: self.viewModel, type: .imageLink)
                    cell.selectionStyle = .none
                    return cell
                case 7:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customButtonCell, for: indexPath)!
                    cell.marginTop.constant = 30
                    cell.setupButton(title: "Register Now")
                    cell.selectionStyle = .none
                    cell.button.rx.tapGesture().when(.recognized).subscribe(onNext: {
                        _ in
                        self.viewModel.setupRegister(user: self.viewModel.user)
                    }).disposed(by: cell.disposeBag)

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
