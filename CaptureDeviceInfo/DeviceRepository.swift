//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation
import AVFoundation

class DeviceRepository {
    static func allCaptureDevices() -> [AVCaptureDevice] {
        var deviceTypes: [AVCaptureDevice.DeviceType] = [
            .builtInTelephotoCamera,
            .builtInDualCamera,
            .builtInWideAngleCamera,
            .builtInTelephotoCamera,
            .builtInMicrophone,
        ]
        if #available(iOS 13.0, *) {
            deviceTypes += [
                .builtInDualWideCamera,
                .builtInTripleCamera,
                .builtInUltraWideCamera,
                .builtInTrueDepthCamera,
            ]
        } else {
            // Fallback on earlier versions
        }
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: nil, position: .unspecified)
        return session.devices
    }
    
    static func allMediaTypes(device: AVCaptureDevice) -> [AVMediaType] {
        var types = [AVMediaType]()
        
        func addMediaTypeIfSupport(_ type: AVMediaType) {
            if device.hasMediaType(type) {
                types.append(type)
            }
        }
        addMediaTypeIfSupport(.audio)
        addMediaTypeIfSupport(.closedCaption)
        addMediaTypeIfSupport(.depthData)
        addMediaTypeIfSupport(.metadata)
        addMediaTypeIfSupport(.metadataObject)
        addMediaTypeIfSupport(.muxed)
        addMediaTypeIfSupport(.subtitle)
        addMediaTypeIfSupport(.text)
        addMediaTypeIfSupport(.timecode)
        addMediaTypeIfSupport(.video)
        
        return types
    }
    
}
