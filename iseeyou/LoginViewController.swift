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
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginFbbtn: UIView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var lbPassword: UILabel!
    @IBOutlet var lbUserName: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    var disposbag = DisposeBag()
    var loginReposytory = AuthRepository()
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitScreen()
        // Do any additional setup after loading the view.
    }

    func setInitScreen() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = true

        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "background_image") ?? UIImage()
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        loginBtn.layer.cornerRadius = 25
        loginBtn.layer.backgroundColor = UIColor(hexString: "#8000ff").cgColor
        loginFbbtn.backgroundColor = UIColor(hexString: "#3700ff")
        loginFbbtn.layer.cornerRadius = 4
        registerBtn.layer.cornerRadius = 25
        registerBtn.layer.backgroundColor = UIColor(hexString: "#8000ff").cgColor
        setupLogin()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = true
    }

    func setupLogin() {
        loginBtn.rx.tapGesture().when(.recognized).subscribe(onNext: {
            _ in
            self.loginReposytory.login(username: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "").subscribe(onNext: {
                _ in
                DialogHelper.shared.showPopup(title: "", msg: "Đăng nhập thành công.!")
            }, onError: {
                _ in
                DialogHelper.shared.showPopup(title: "", msg: "Có lỗi xảy ra khi đăng nhập, vui lòng kiểm tra lại.")
            }).disposed(by: self.disposbag)
        }).disposed(by: disposbag)

        registerBtn.rx.tapGesture().when(.recognized).subscribe(onNext: {
            _ in
            let vc = R.storyboard.main.registerViewcontroller()!
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposbag)
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
