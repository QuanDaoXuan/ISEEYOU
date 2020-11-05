//
//  SignalingMessage.swift
//  iseeyou
//
//  Created by resopt on 11/2/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation

struct SignalingMessage: Codable {
    let type: String
    let sessionDescription: SDP?
    let candidate: Candidate?
}

struct SDP: Codable {
    let sdp: String
}

struct Candidate: Codable {
    let sdp: String
    let sdpMLineIndex: Int32
    let sdpMid: String
}
