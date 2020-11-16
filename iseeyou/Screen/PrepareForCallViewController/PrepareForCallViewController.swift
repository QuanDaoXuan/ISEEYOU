//
//  PrepareForCallViewController.swift
//  iseeyou
//
//  Created by resopt on 11/12/20.
//  Copyright © 2020 truc. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PrepareForCallViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel: PrepareForCallModel!
    var loginReposytory = AuthRepository()
    var disposbag = DisposeBag()
    var webRTCClient: RTCClient!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(R.nib.topProfileCell)
        tableView.register(R.nib.customButtonCallCell)

        tableView.estimatedRowHeight = 250

        viewModel.datasource.bind(to: tableView.rx.items) { [unowned self]

            (_, index, value) -> UITableViewCell in
            switch value {
                case 0:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topProfileCell, for: indexPath)!
                    cell.setupProfile(user: self.viewModel.user)
                    cell.coverImageView.isHidden = true
                    cell.coverImageHeight.constant = 75
                    cell.selectionStyle = .none
                    return cell
                case 1:
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customButtonCallCell, for: indexPath)!
                    cell.selectionStyle = .none
                    print("123")
                    cell.videoCallBtn.rx.tapGesture().when(.recognized).subscribe(onNext: {
                        _ in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callvideo"), object: nil)
                        let vc = R.storyboard.main.videoCallViewController()!
                        vc.webRTCClient = self.webRTCClient
                        self.navigationController?.pushViewController(vc, animated: true)
                    }).disposed(by: cell.disposeBag)
                    cell.contentView.rx.tapGesture().when(.recognized).subscribe(onNext: {
                        _ in
                        print("123")
                    }).disposed(by: cell.disposeBag)

                    return cell
                default:
                    let cell = UITableViewCell()
                    return cell
            }
        }.disposed(by: disposbag)
    }

    func setInitScreen() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.backBarButtonItem?.title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        setInitScreen()
    }
}
