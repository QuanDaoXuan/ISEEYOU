//
//  ApiServices.swift
//  JWI
//
//  Created by Hung Tran on 5/4/20.
//  Copyright © 2020 hungtd. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift
import SwiftEntryKit
import SwiftyJSON

var countLogout: Int = 0
class APIService {

    static let shareManager = APIService()
    let bag = DisposeBag()
    var countShowMessage: Int = 0

    fileprivate let session: Session = {
        let configuration = URLSessionConfiguration.default
        let session = Session(configuration: configuration)
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return session
    }()

    static func checkNetworkAvailable() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    func callAPI(endpoint: String? = nil, path: String, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil) -> Observable<JSON> {
        return Observable.create { observer in
            if !APIService.checkNetworkAvailable() {
                let error = NSError(domain: "error", code: 999, userInfo: nil)
                print(error)
                DialogHelper.shared.hideHUD()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    DialogHelper.shared.showPopup(title: "", msg: "internet error")
                    observer.onCompleted()
                }
            } else {
                var apiUrl = ""
                if let endpoint = endpoint {
                    apiUrl = endpoint + path
                } else {
                    apiUrl = APIUrl.url.rawValue + path
                }
                print(params)

                let request = self.session.request(apiUrl, method: method, parameters: params, encoding: encoding, headers: headers)
                request.responseJSON { response in
                    let code = response.response?.statusCode ?? HttpCode.cancel.rawValue

                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        if code == HttpCode.success.rawValue {
                            observer.onNext(json)
                        } else {
                            let dict = json.dictionaryValue
                            let error = NSError(domain: "error", code: code, userInfo: dict)
                            print(error)
                            observer.onError(error)
                        }
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
                return Disposables.create {
                    request.cancel()
                }
            }
            return Disposables.create()
        }
    }
}

extension APIService {
    public static func returnHeaders() -> HTTPHeaders? {
        // retrieve token from cache

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return headers

//        return nil
    }
}
