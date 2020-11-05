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

class VideoCallViewController: UIViewController, WebSocketDelegate, RTCClientDelegate, CameraSessionDelegate {
    enum messageType {
        case greet
        case introduce
        
        func text() -> String {
            switch self {
            case .greet:
                return "Hello!"
            case .introduce:
                return "I'm " + UIDevice().name
            }
        }
    }
    
    // MARK: - Properties
    
    var webRTCClient: RTCClient!
    var socket: WebSocket!
    var tryToConnectWebSocket: Timer!
    var cameraSession: CameraSession?
    
    // You can create video source from CMSampleBuffer :)
    var useCustomCapturer: Bool = false
    var cameraFilter: CameraFilter?
    
    // Constants
    
    // MARK: Change this ip address in your case
    
    let ipAddress: String = "10.118.0.49"
    let wsStatusMessageBase = "WebSocket: "
    let webRTCStatusMesasgeBase = "WebRTC: "
    let likeStr: String = "Like"
    
    // UI
    var wsStatusLabel: UILabel!
    var webRTCStatusLabel: UILabel!
    var webRTCMessageLabel: UILabel!
    var likeImage: UIImage!
    var likeImageViewRect: CGRect!
    
    // MARK: - ViewController Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
        // simulator does not have camera
        useCustomCapturer = false
        #endif
        
        webRTCClient = RTCClient()
        webRTCClient.delegate = self
        webRTCClient.setup(videoTrack: true, audioTrack: true, dataChannel: true, customFrameCapturer: useCustomCapturer)
        
        // if simulator
        if useCustomCapturer {
            print("--- use custom capturer ---")
            cameraSession = CameraSession()
            cameraSession?.delegate = self
            cameraSession?.setupSession()
            
            cameraFilter = CameraFilter()
        }
        
        socket = WebSocket(url: URL(string: "ws://" + ipAddress + ":8080/")!)
        socket.delegate = self
        
        tryToConnectWebSocket = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            if self.webRTCClient.isConnected || self.socket.isConnected {
                return
            }
            
            self.socket.connect()
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI
    
    private func setupUI() {
        let remoteVideoViewContainter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width(), height: ScreenSizeUtil.height() * 0.7))
        remoteVideoViewContainter.backgroundColor = .gray
        view.addSubview(remoteVideoViewContainter)
        
        let remoteVideoView = webRTCClient.remoteVideoView()
        webRTCClient.setupRemoteViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width() * 0.7, height: ScreenSizeUtil.height() * 0.7))
        remoteVideoView.center = remoteVideoViewContainter.center
        remoteVideoViewContainter.addSubview(remoteVideoView)
        
        let localVideoView = webRTCClient.localVideoView()
        webRTCClient.setupLocalViewFrame(frame: CGRect(x: 0, y: 0, width: ScreenSizeUtil.width() / 3, height: ScreenSizeUtil.height() / 3))
        localVideoView.center.y = view.center.y
        localVideoView.subviews.last?.isUserInteractionEnabled = true
        view.addSubview(localVideoView)
        
        let localVideoViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: localVideoView.frame.width, height: localVideoView.frame.height))
        localVideoViewButton.backgroundColor = UIColor.clear
        localVideoViewButton.addTarget(self, action: #selector(localVideoViewTapped(_:)), for: .touchUpInside)
        localVideoView.addSubview(localVideoViewButton)
        
        let likeButton = UIButton(frame: CGRect(x: remoteVideoViewContainter.right - 50, y: remoteVideoViewContainter.bottom - 50, width: 40, height: 40))
        likeButton.backgroundColor = UIColor.clear
        likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(likeButton)
        likeButton.setImage(UIImage(named: "like_border.png"), for: .normal)
        
        likeImage = UIImage(named: "like_filled.png")
        likeImageViewRect = CGRect(x: remoteVideoViewContainter.right - 70, y: likeButton.top - 70, width: 60, height: 60)
        
        let messageButton = UIButton(frame: CGRect(x: likeButton.left - 220, y: remoteVideoViewContainter.bottom - 50, width: 210, height: 40))
        messageButton.setBackgroundImage(UIColor.green.rectImage(width: messageButton.frame.width, height: messageButton.frame.height), for: .normal)
        messageButton.addTarget(self, action: #selector(sendMessageButtonTapped(_:)), for: .touchUpInside)
        messageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        messageButton.setTitle(messageType.greet.text(), for: .normal)
        messageButton.layer.cornerRadius = 20
        messageButton.layer.masksToBounds = true
        view.addSubview(messageButton)
        
        wsStatusLabel = UILabel(frame: CGRect(x: 0, y: remoteVideoViewContainter.bottom, width: ScreenSizeUtil.width(), height: 30))
        wsStatusLabel.textAlignment = .center
        view.addSubview(wsStatusLabel)
        webRTCStatusLabel = UILabel(frame: CGRect(x: 0, y: wsStatusLabel.bottom, width: ScreenSizeUtil.width(), height: 30))
        webRTCStatusLabel.textAlignment = .center
        webRTCStatusLabel.text = webRTCStatusMesasgeBase + "initialized"
        view.addSubview(webRTCStatusLabel)
        webRTCMessageLabel = UILabel(frame: CGRect(x: 0, y: webRTCStatusLabel.bottom, width: ScreenSizeUtil.width(), height: 30))
        webRTCMessageLabel.textAlignment = .center
        webRTCMessageLabel.textColor = .black
        view.addSubview(webRTCMessageLabel)
        
        let buttonWidth = ScreenSizeUtil.width() * 0.4
        let buttonHeight: CGFloat = 60
        let buttonRadius: CGFloat = 30
        let callButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        callButton.setBackgroundImage(UIColor.blue.rectImage(width: callButton.frame.width, height: callButton.frame.height), for: .normal)
        callButton.layer.cornerRadius = buttonRadius
        callButton.layer.masksToBounds = true
        callButton.center.x = ScreenSizeUtil.width() / 4
        callButton.center.y = webRTCStatusLabel.bottom + (ScreenSizeUtil.height() - webRTCStatusLabel.bottom) / 2
        callButton.setTitle("Call", for: .normal)
        callButton.titleLabel?.font = UIFont.systemFont(ofSize: 23)
        callButton.addTarget(self, action: #selector(callButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(callButton)
        
        let hangupButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        hangupButton.setBackgroundImage(UIColor.red.rectImage(width: hangupButton.frame.width, height: hangupButton.frame.height), for: .normal)
        hangupButton.layer.cornerRadius = buttonRadius
        hangupButton.layer.masksToBounds = true
        hangupButton.center.x = ScreenSizeUtil.width() / 4 * 3
        hangupButton.center.y = callButton.center.y
        hangupButton.setTitle("hang up", for: .normal)
        hangupButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        hangupButton.addTarget(self, action: #selector(hangupButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(hangupButton)
    }
    
    // MARK: - UI Events
    
    @objc func callButtonTapped(_ sender: UIButton) {
        if !webRTCClient.isConnected {
            webRTCClient.connect(onSuccess: { (offerSDP: RTCSessionDescription) -> Void in
                self.sendSDP(sessionDescription: offerSDP)
            })
        }
    }
    
    @objc func hangupButtonTapped(_ sender: UIButton) {
        if webRTCClient.isConnected {
            webRTCClient.disconnect()
        }
    }
    
    @objc func sendMessageButtonTapped(_ sender: UIButton) {
        webRTCClient.sendMessge(message: (sender.titleLabel?.text!)!)
        if sender.titleLabel?.text == messageType.greet.text() {
            sender.setTitle(messageType.introduce.text(), for: .normal)
        } else if sender.titleLabel?.text == messageType.introduce.text() {
            sender.setTitle(messageType.greet.text(), for: .normal)
        }
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        let data = likeStr.data(using: String.Encoding.utf8)
        webRTCClient.sendData(data: data!)
    }
    
    @objc func localVideoViewTapped(_ sender: UITapGestureRecognizer) {
//        if let filter = self.cameraFilter {
//            filter.changeFilter(filter.filterType.next())
//        }
        webRTCClient.switchCameraPosition()
    }
    
    private func startLikeAnimation() {
        let likeImageView = UIImageView(frame: likeImageViewRect)
        likeImageView.backgroundColor = UIColor.clear
        likeImageView.contentMode = .scaleAspectFit
        likeImageView.image = likeImage
        likeImageView.alpha = 1.0
        view.addSubview(likeImageView)
        UIView.animate(withDuration: 0.5, animations: {
            likeImageView.alpha = 0.0
        }) { _ in
            likeImageView.removeFromSuperview()
        }
    }
    
    // MARK: - WebRTC Signaling
    
    private func sendSDP(sessionDescription: RTCSessionDescription) {
        var type = ""
        if sessionDescription.type == .offer {
            type = "offer"
        } else if sessionDescription.type == .answer {
            type = "answer"
        }
        
        let sdp = SDP(sdp: sessionDescription.sdp)
        let signalingMessage = SignalingMessage(type: type, sessionDescription: sdp, candidate: nil)
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!
            
            if socket.isConnected {
                socket.write(string: message)
            }
        } catch {
            print(error)
        }
    }
    
    private func sendCandidate(iceCandidate: RTCIceCandidate) {
        let candidate = Candidate(sdp: iceCandidate.sdp, sdpMLineIndex: iceCandidate.sdpMLineIndex, sdpMid: iceCandidate.sdpMid!)
        let signalingMessage = SignalingMessage(type: "candidate", sessionDescription: nil, candidate: candidate)
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!
            
            if socket.isConnected {
                socket.write(string: message)
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - WebSocket Delegate

extension VideoCallViewController {
    func websocketDidConnect(socket: WebSocketClient) {
        print("-- websocket did connect --")
        wsStatusLabel.text = wsStatusMessageBase + "connected"
        wsStatusLabel.textColor = .green
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("-- websocket did disconnect --")
        wsStatusLabel.text = wsStatusMessageBase + "disconnected"
        wsStatusLabel.textColor = .red
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        do {
            let signalingMessage = try JSONDecoder().decode(SignalingMessage.self, from: text.data(using: .utf8)!)
            
            if signalingMessage.type == "offer" {
                webRTCClient.receiveOffer(offerSDP: RTCSessionDescription(type: .offer, sdp: (signalingMessage.sessionDescription?.sdp)!), onCreateAnswer: { (answerSDP: RTCSessionDescription) -> Void in
                    self.sendSDP(sessionDescription: answerSDP)
                })
            } else if signalingMessage.type == "answer" {
                webRTCClient.receiveAnswer(answerSDP: RTCSessionDescription(type: .answer, sdp: (signalingMessage.sessionDescription?.sdp)!))
            } else if signalingMessage.type == "candidate" {
                let candidate = signalingMessage.candidate!
                webRTCClient.receiveCandidate(candidate: RTCIceCandidate(sdp: candidate.sdp, sdpMLineIndex: candidate.sdpMLineIndex, sdpMid: candidate.sdpMid))
            }
        } catch {
            print(error)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
}

// MARK: - WebRTCClient Delegate

extension VideoCallViewController {
    func didGenerateCandidate(iceCandidate: RTCIceCandidate) {
        sendCandidate(iceCandidate: iceCandidate)
    }
    
    func didIceConnectionStateChanged(iceConnectionState: RTCIceConnectionState) {
        var state = ""
        
        switch iceConnectionState {
        case .checking:
            state = "checking..."
        case .closed:
            state = "closed"
        case .completed:
            state = "completed"
        case .connected:
            state = "connected"
        case .count:
            state = "count..."
        case .disconnected:
            state = "disconnected"
        case .failed:
            state = "failed"
        case .new:
            state = "new..."
        }
        webRTCStatusLabel.text = webRTCStatusMesasgeBase + state
    }
    
    func didConnectWebRTC() {
        webRTCStatusLabel.textColor = .green
        
        // MARK: Disconnect websocket
        
        socket.disconnect()
    }
    
    func didDisconnectWebRTC() {
        webRTCStatusLabel.textColor = .red
    }
    
    func didOpenDataChannel() {
        print("did open data channel")
    }
    
    func didReceiveData(data: Data) {
        if data == likeStr.data(using: String.Encoding.utf8) {
            startLikeAnimation()
        }
    }
    
    func didReceiveMessage(message: String) {
        webRTCMessageLabel.text = message
    }
}

// MARK: - CameraSessionDelegate

extension VideoCallViewController {
    func didOutput(_ sampleBuffer: CMSampleBuffer) {
        if useCustomCapturer {
            if let cvpixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                if let buffer = cameraFilter?.apply(cvpixelBuffer) {
                    webRTCClient.captureCurrentFrame(sampleBuffer: buffer)
                } else {
                    print("no applied image")
                }
            } else {
                print("no pixelbuffer")
            }
            //            self.webRTCClient.captureCurrentFrame(sampleBuffer: buffer)
        }
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
