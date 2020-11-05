//
//  RTCSimulatorVideoDecoderFactory.swift
//  iseeyou
//
//  Created by resopt on 11/2/20.
//  Copyright © 2020 truc. All rights reserved.
//

import Foundation
import WebRTC


class RTCSimulatorVideoDecoderFactory: RTCDefaultVideoDecoderFactory {
    
    override init() {
        super.init()
    }
    
    override func supportedCodecs() -> [RTCVideoCodecInfo] {
        var codecs = super.supportedCodecs()
        codecs = codecs.filter{$0.name != "H264"}
        return codecs
    }
}
