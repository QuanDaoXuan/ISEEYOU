//
//  DialogHelper.swift
//  iseeyou
//
//  Created by resopt on 10/30/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SVProgressHUD
import SwiftEntryKit
import UIKit

class DialogHelper {
    static let shared = DialogHelper()

    func showAlertInValidBarCode(okAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: Constant.INVALID_BARCODE_FORMAT_TITLE, message: Constant.INVALID_BARCODE_FORMAT_CONTENT, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.INVALID_BARCODE_FORMAT_BUTTON, style: .default, handler: okAction))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIApplication.getTopViewController()?.present(alert, animated: true, completion: nil)
        }
    }

    func showPopup(title: String?, msg: String) {
        let alert = UIAlertController(title: title ?? "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            print("handle")
        }))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIApplication.getTopViewController()?.present(alert, animated: true, completion: nil)
        }
    }

    func hideHUD() {
        SVProgressHUD.popActivity()
    }

    func showHUD() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
}

extension UIApplication {
    class func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            // topController should now be your topmost view controller
            return topController
        }
        return nil
    }
}
