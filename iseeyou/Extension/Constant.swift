//
//  File.swift
//  iseeyou
//
//  Created by resopt on 10/30/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import UIKit
enum HttpCode: Int {
    case success = 200
    case cancel = -999
    case NetworkError = 504
}

class RamdomName {
    let names = ["Ái Hồng", "Ái Khanh", "Ánh Hồng", "Ánh Nguyệt", "Hạ Phương", "Hạ Uyên", "Hải Ân"]

    func getRandom() -> String {
        return self.names[Int.random(in: 0 ... self.names.count - 1)]
    }
}

enum APIUrl: String {
    #if DEV
    case url = "http:connect-thedots.xyz:3000/"
    #elseif STAG
    case url = "http:18.188.116.218:3000/"
    #else
    case url = "http:18.188.116.218:3000/"
    #endif
}

class Constant {
    static let NO = "いいえ"
    static let YES = "はい"
    static let MESSAGE_CONFIRM_USE_CAMERA = "カメラでQRコードをスキャンできるようにしてください"
    static let cantGetDate = "an error occurred while processing your request"
    static let disconnect = "サーバー内部エラー"
    static let LOST_INTERNET_TITLE = "インターネット接続できない"
    static let LOST_INTERNET_CONTENT = "サーバに送受信するには、モバイルデータ通信をオンにするかWi-Fiを使用してください。"
    static let LOST_INTERNET_BTN_GOTOSETTING = "設定"
    static let ERROR_DURING_REQUEST_TITLE = "通信エラー"
    static let ERROR_DURING_REQUEST_CONTENT = "通信エラーが発生しました。\n通信環境をご確認のうえ、再度実行してください。"
    static let ERROR_DURING_REQUEST_BTN_REQUEST_AGAIN = "リトライ"
    static let COUNT_MSG_SCAN_SUCCESS_SCREEN = "秒後にトップ画面に戻る）"
    static let INVALID_BARCODE_FORMAT_TITLE = "読み取り結果"
    static let INVALID_BARCODE_FORMAT_CONTENT = "読み取れない形式のバーコードです。"
    static let INVALID_BARCODE_FORMAT_BUTTON = "確認"

    static let needStartCameraSession = "needStartCameraSession"
}

extension UIColor {
    func rectImage(width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(self.cgColor)
        contextRef?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    func circleImage(width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(self.cgColor)
        contextRef?.fillEllipse(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UIView {
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }

    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }

    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
}
