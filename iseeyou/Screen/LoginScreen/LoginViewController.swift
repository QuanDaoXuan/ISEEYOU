//
//  LoginViewController.swift
//  iseeyou
//
//  Created by resopt on 7/24/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel = LoginViewModel()
    var disposbag = DisposeBag()
    var loginReposytory = AuthRepository()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
                cell.bindTextField(viewModel: self.viewModel, type: 1)
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            case 2:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.textFieldAndLabelCell, for: indexPath)!
                cell.setupCell(title: "Nhập password", placeHoder: "enter your password")
                cell.bindTextField(viewModel: self.viewModel, type: 2)
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            case 0:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topRegisterCell, for: indexPath)!
                cell.buttonView.setTitle("LOGIN", for: .normal)
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                return cell
            case 5:
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customButtonCell, for: indexPath)!
                cell.setupButton(title: "Login now")
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                cell.button.rx.tapGesture().when(.recognized).subscribe(onNext: {
                    _ in
                    self.viewModel.setupLogin()
            }).disposed(by: cell.disposeBag)

                return cell
            default:
                return UITableViewCell()
            }
        }.disposed(by: disposeBag)
    }

    func setInitScreen() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = true
    }
}

import UIKit

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
