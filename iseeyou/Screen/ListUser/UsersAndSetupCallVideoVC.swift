//
//  ListUsersViewController.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import RxCocoa
import RxSwift

import Starscream
import UIKit
import WebRTC

class UsersAndSetupCallVideoVC: UITableViewController, WebSocketDelegate, RTCClientDelegate, CameraSessionDelegate {
    // MARK: - Properties
    
    var friendId = ""
    let viewModel = ListUsersModel()
    var disposeBag = DisposeBag()
    let notificationCenter = NotificationCenter.default
    
    var webRTCClient: RTCClient!
    var socket: WebSocket!
    var tryToConnectWebSocket: Timer!
    var cameraSession: CameraSession?
    
    var useCustomCapturer: Bool = false
    
    // MARK: Change this ip address
    
    let ipAddress: String = "10.112.0.46"
    
    func setupVideoCall() {
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
        }
        
        tryToConnectWebSocket = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            
            if self.viewModel.user.idUsers != "" && self.socket == nil {
                self.socket = WebSocket(url: URL(string: "ws://" + self.ipAddress + ":8080/" + self.viewModel.user.idUsers)!)
                self.socket.delegate = self
            }
            if self.socket == nil {
                return
            }
            
            if self.webRTCClient.isConnected || self.socket.isConnected {
                return
            }
            self.socket.connect()
            
//            print("connected socket")
        })
    }
    
    deinit {
        print("denit call viewcontroller")
    }
    
    @objc func callButtonTapped(_ sender: UIButton) {
        if !webRTCClient.isConnected {
            webRTCClient.connect(onSuccess: { (offerSDP: RTCSessionDescription) -> Void in
                self.sendSDP(sessionDescription: offerSDP)
            })
        }
    }
    
    private func sendSDP(sessionDescription: RTCSessionDescription) {
        var type = ""
        if sessionDescription.type == .offer {
            type = "offer"
        } else if sessionDescription.type == .answer {
            type = "answer"
        }
        
        let sdp = SDP(sdp: sessionDescription.sdp)
        let signalingMessage = SignalingMessage(type: type, sessionDescription: sdp, candidate: nil, friendId: friendId)
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!
            
            if socket.isConnected {
                socket.write(string: message)
                print("sendSDP write")
            }
        } catch {
            print(error)
        }
    }
    
    private func sendCandidate(iceCandidate: RTCIceCandidate) {
        let candidate = Candidate(sdp: iceCandidate.sdp, sdpMLineIndex: iceCandidate.sdpMLineIndex, sdpMid: iceCandidate.sdpMid!)
        let signalingMessage = SignalingMessage(type: "candidate", sessionDescription: nil, candidate: candidate, friendId: friendId)
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!
            
            if socket.isConnected {
                socket.write(string: message)
                print("candidate write")
            }
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.getListUsers()
        setupVideoCall()
        notificationCenter.addObserver(self, selector: #selector(callButtonTapped(_:)), name: NSNotification.Name(rawValue: "callvideo"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(disconnectSocket), name: NSNotification.Name(rawValue: "disconnectSocket"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func disconnectSocket() {
        socket.disconnect()
        tryToConnectWebSocket.invalidate()
        webRTCClient.disconnect()
    }
    
    func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(R.nib.listUserCell)
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 100
        
        viewModel.datasource.bind(to: tableView.rx.items) { [unowned self]
            
            (_, index, value) -> UITableViewCell in
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listUserCell, for: indexPath)!
            cell.setupCell(user: value)
            cell.contentView.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self]
                _ in
                let vc = R.storyboard.prepare.prepareForCallViewController()!
                let model = PrepareForCallModel(user: value)
                vc.viewModel = model
                vc.webRTCClient = self.webRTCClient
                self.friendId = value.idUsers
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: cell.disposeBag)
            cell.selectionStyle = .none
            return cell
            
        }.disposed(by: disposeBag)
    }
}

extension UsersAndSetupCallVideoVC {
    func websocketDidConnect(socket: WebSocketClient) {
        print("-- websocket did connect --")
        // set Green Lb and connected in text
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        do {
            let signalingMessage = try JSONDecoder().decode(SignalingMessage.self, from: text.data(using: .utf8)!)
            if signalingMessage.type == "offer" {
                friendId = signalingMessage.friendId
                let vc = R.storyboard.main.videoCallViewController()!
                vc.webRTCClient = webRTCClient
                navigationController?.pushViewController(vc, animated: true)
            }
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

extension UsersAndSetupCallVideoVC {
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
            navigationController?.popViewController(animated: true)
        case .failed:
            state = "failed"
        case .new:
            state = "new..."
        @unknown default:
            state = "new..."
        }
        print(state)
    }
    
    func didConnectWebRTC() {
        socket.disconnect()
    }
    
    func didDisconnectWebRTC() {}
    
    func didOpenDataChannel() {
        print("did open data channel")
    }
    
    func didReceiveData(data: Data) {}
    
    func didReceiveMessage(message: String) {}
}

// MARK: - CameraSessionDelegate

extension UsersAndSetupCallVideoVC {
    func didOutput(_ sampleBuffer: CMSampleBuffer) {
        if useCustomCapturer {
            webRTCClient.captureCurrentFrame(sampleBuffer: sampleBuffer)
        }
    }
}
