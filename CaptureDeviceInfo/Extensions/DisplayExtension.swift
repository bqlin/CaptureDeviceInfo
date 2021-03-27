//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation
import AVFoundation

protocol Displayable {
    var displayText: String { get }
}

// MARK: system

extension String: Displayable {
    var displayText: String { self }
}

extension Bool: Displayable {
    var displayText: String {
        self ? "✅" : "❎"
    }
}

extension Array: Displayable {
    var displayText: String {
        var text = ""
        guard count > 0 else {
            return "[]"
        }
        
        for e in self {
            if let displayable = e as? Displayable {
                text += "\(displayable.displayText)\n"
            } else {
                text += "\(e)\n"
            }
        }
        text.removeLast()
        return text
    }
}

extension CMVideoDimensions: Displayable {
    var displayText: String {
        "\(width)×\(height)"
    }
}

extension AVCaptureDevice.Format.AutoFocusSystem: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .none:
                text = "none"
            case .contrastDetection:
                text = "contrastDetection"
            case .phaseDetection:
                text = "phaseDetection"
        }
        return text
    }
}

extension AVMediaType: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .audio:
                text = "audio media"
            case .closedCaption:
                text = "closed-caption content"
            case .depthData:
                text = "depth data"
            case .metadata:
                text = "metadata"
            case .metadataObject:
                text = "metadata objects"
            case .muxed:
                text = "muxed media"
            case .subtitle:
                text = "subtitles"
            case .text:
                text = "text"
            case .timecode:
                text = "timecode"
            case .video:
                text = "video"
            default:
                text = rawValue
        }
        return text
    }
}

extension AVCaptureDevice.Position: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .front:
                text = "front"
            case .back:
                text = "back"
            case .unspecified:
                text = "unspecified"
        }
        
        return text
    }
}

extension AVCaptureVideoStabilizationMode: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .off:
                text = "off"
            case .standard:
                text = "standard"
            case .cinematic:
                text = "cinematic"
            case .cinematicExtended:
                text = "cinematicExtended"
            case .auto:
                text = "auto"
        }
        
        return text
    }
}

extension AVFrameRateRange: Displayable {
var displayText: String {
    "\(minFrameRate)~\(maxFrameRate)"
}
}