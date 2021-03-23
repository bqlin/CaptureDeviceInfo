//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation
import AVFoundation

protocol Displayable {
    var displayName: String { get }
}

extension AVMediaType: Displayable {
    var displayName: String {
        var name = ""
        switch self {
            case .audio:
                name = "audio media"
            case .closedCaption:
                name = "closed-caption content"
            case .depthData:
                name = "depth data"
            case .metadata:
                name = "metadata"
            case .metadataObject:
                name = "metadata objects"
            case .muxed:
                name = "muxed media"
            case .subtitle:
                name = "subtitles"
            case .text:
                name = "text"
            case .timecode:
                name = "timecode"
            case .video:
                name = "video"
            default:
                name = self.rawValue
        }
        return name
    }
}

extension AVCaptureDevice.Position: Displayable {
    var displayName: String {
        var name = ""
        switch self {
            case .front:
                name = "front"
            case .back:
                name = "back"
            case .unspecified:
                name = "unspecified"
        }
        
        return name
    }
}