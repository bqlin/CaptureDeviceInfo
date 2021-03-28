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
                text = "contrast detection"
            case .phaseDetection:
                text = "phase detection"
            @unknown default:
                fatalError()
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
            @unknown default:
                fatalError()
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
                text = "cinematic extended"
            case .auto:
                text = "auto"
            @unknown default:
                fatalError()
        }
        
        return text
    }
}

extension AVFrameRateRange: Displayable {
    var displayText: String {
        "\(minFrameRate)~\(maxFrameRate)"
    }
}

extension AVCaptureColorSpace: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .sRGB:
                text = "sRGB"
            case .P3_D65:
                text = "P3_D65"
            @unknown default:
                fatalError()
        }
        return text
    }
}

extension AVCaptureDevice.ExposureMode: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .locked:
                text = "locked"
            case .autoExpose:
                text = "auto expose"
            case .continuousAutoExposure:
                text = "continuous auto exposure"
            case .custom:
                text = "custom"
            @unknown default:
                fatalError()
        }
        
        return text
    }
}

extension AVCaptureDevice.FocusMode: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .locked:
                text = "locked"
            case .autoFocus:
                text = "autoFocus"
            case .continuousAutoFocus:
                text = "continuousAutoFocus"
            @unknown default:
                fatalError()
        }
        
        return text
    }
}

extension AVCaptureDevice.AutoFocusRangeRestriction: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .none:
                text = "none"
            case .near:
                text = "near"
            case .far:
                text = "far"
            @unknown default:
                fatalError()
        }
        
        return text
    }
}

extension AVCaptureDevice.FlashMode: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .off:
                text = "off"
            case .on:
                text = "on"
            case .auto:
                text = "auto"
            @unknown default:
                fatalError()
        }
        
        return text
    }
}

extension AVCaptureDevice.TorchMode: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .off:
                text = "off"
            case .on:
                text = "on"
            case .auto:
                text = "auto"
            @unknown default:
                fatalError()
        }
        
        return text
    }
}

extension AVCaptureDevice.WhiteBalanceMode: Displayable {
    var displayText: String {
        var text = ""
        switch self {
            case .locked:
                text = "locked"
            case .autoWhiteBalance:
                text = "auto white balance"
            case .continuousAutoWhiteBalance:
                text = "continuous auto white balance"
            @unknown default:
                fatalError()
        }
        
        return text
    }
}

extension AVCaptureDevice.DeviceType: Displayable {
    var displayText: String {
        var text = self.rawValue
        if let range = text.range(of: "AVCaptureDeviceType") {
            text.removeSubrange(range)
        }
        
        return text
    }
}
