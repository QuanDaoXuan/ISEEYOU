//
//  VideoCallViewController.swift
//  iseeyou
//
//  Created by resopt on 11/2/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Starscream
import UIKit
import WebRTC

class VideoCallViewController: UIViewController {
    var webRTCClient: RTCClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        let remoteVideoViewContainter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width(), height: ScreenSizeUtil.height() * 0.7))
        remoteVideoViewContainter.backgroundColor = .gray
        view.addSubview(remoteVideoViewContainter)
        
        let remoteVideoView = webRTCClient.remoteVideoView()
        webRTCClient.setupRemoteViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width() * 0.7, height: ScreenSizeUtil.height() * 0.7))
        remoteVideoView.center = remoteVideoViewContainter.center
        remoteVideoViewContainter.addSubview(remoteVideoView)
        
        let localVideoView = webRTCClient.localVideoView()
        webRTCClient.setupLocalViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width() / 3, height: ScreenSizeUtil.height() / 4))
        localVideoView.center.y = view.center.y
        localVideoView.subviews.last?.isUserInteractionEnabled = true
        view.addSubview(localVideoView)
        
        let localVideoViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: localVideoView.frame.width, height: localVideoView.frame.height))
        localVideoViewButton.backgroundColor = UIColor.clear
        localVideoView.addSubview(localVideoViewButton)
        
        let buttonWidth = ScreenSizeUtil.width() * 0.4
        let buttonHeight: CGFloat = 60
        let buttonRadius: CGFloat = 30
        
        let hangupButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        hangupButton.setBackgroundImage(UIColor.red.rectImage(width: hangupButton.frame.width, height: hangupButton.frame.height), for: .normal)
        hangupButton.layer.cornerRadius = buttonRadius
        hangupButton.layer.masksToBounds = true
        hangupButton.center.x = ScreenSizeUtil.width() / 2
        hangupButton.center.y = ScreenSizeUtil.height() - (tabBarController?.tabBar.frame.height ?? 100) - 30
        hangupButton.setTitle("hang up", for: .normal)
        hangupButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        hangupButton.addTarget(self, action: #selector(hangupButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(hangupButton)
    }
    
    deinit {
        print("denit ViewController")
    }
    
    @objc func hangupButtonTapped(_ sender: UIButton) {
        if webRTCClient.isConnected {
            webRTCClient.disconnect()
        }
        navigationController?.popViewController(animated: true)
    }
}

class ScreenSizeUtil {
    static func width() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func height() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
