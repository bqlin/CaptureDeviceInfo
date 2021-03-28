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
        
        func addIfSupport(_ type: AVMediaType) {
            if device.hasMediaType(type) {
                types.append(type)
            }
        }
        
        addIfSupport(.audio)
        addIfSupport(.closedCaption)
        addIfSupport(.depthData)
        addIfSupport(.metadata)
        addIfSupport(.metadataObject)
        addIfSupport(.muxed)
        addIfSupport(.subtitle)
        addIfSupport(.text)
        addIfSupport(.timecode)
        addIfSupport(.video)
        
        return types
    }
    
    static func allVideoStabilizationMode(format: AVCaptureDevice.Format) -> [AVCaptureVideoStabilizationMode] {
        var modes = [AVCaptureVideoStabilizationMode]()
        
        func addIfSupport(_ mode: AVCaptureVideoStabilizationMode) {
            if format.isVideoStabilizationModeSupported(mode) {
                modes.append(mode)
            }
        }
        
        addIfSupport(.auto)
        addIfSupport(.standard)
        addIfSupport(.cinematic)
        if #available(iOS 13.0, *) {
            addIfSupport(.cinematicExtended)
        } else {
            // Fallback on earlier versions
        }
        addIfSupport(.off)
        
        return modes
    }
    
    static func allExposureMode(device: AVCaptureDevice) -> [AVCaptureDevice.ExposureMode] {
        var modes = [AVCaptureDevice.ExposureMode]()
        
        func addIfSupport(_ mode: AVCaptureDevice.ExposureMode) {
            if device.isExposureModeSupported(mode) {
                modes.append(mode)
            }
        }
        
        addIfSupport(.locked)
        addIfSupport(.autoExpose)
        addIfSupport(.continuousAutoExposure)
        addIfSupport(.custom)
        
        return modes
    }
    
    static func allFocusModeSupported(device: AVCaptureDevice) -> [AVCaptureDevice.FocusMode] {
        var modes = [AVCaptureDevice.FocusMode]()
        
        func addIfSupport(_ mode: AVCaptureDevice.FocusMode) {
            if device.isFocusModeSupported(mode) {
                modes.append(mode)
            }
        }
        
        addIfSupport(.locked)
        addIfSupport(.autoFocus)
        addIfSupport(.continuousAutoFocus)
        
        return modes
    }
    
    static func allFlashModeSupported(device: AVCaptureDevice) -> [AVCaptureDevice.FlashMode] {
        var modes = [AVCaptureDevice.FlashMode]()
        
        func addIfSupport(_ mode: AVCaptureDevice.FlashMode) {
            if device.isFlashModeSupported(mode) {
                modes.append(mode)
            }
        }
        
        addIfSupport(.off)
        addIfSupport(.on)
        addIfSupport(.auto)
        
        return modes
    }
    
    static func allTorchModeSupported(device: AVCaptureDevice) -> [AVCaptureDevice.TorchMode] {
        var modes = [AVCaptureDevice.TorchMode]()
        
        func addIfSupport(_ mode: AVCaptureDevice.TorchMode) {
            if device.isTorchModeSupported(mode) {
                modes.append(mode)
            }
        }
        
        addIfSupport(.off)
        addIfSupport(.on)
        addIfSupport(.auto)
        
        return modes
    }
    
    static func allWhiteBalanceModeSupported(device: AVCaptureDevice) -> [AVCaptureDevice.WhiteBalanceMode] {
        var modes = [AVCaptureDevice.WhiteBalanceMode]()
        
        func addIfSupport(_ mode: AVCaptureDevice.WhiteBalanceMode) {
            if device.isWhiteBalanceModeSupported(mode) {
                modes.append(mode)
            }
        }
        
        addIfSupport(.locked)
        addIfSupport(.autoWhiteBalance)
        addIfSupport(.continuousAutoWhiteBalance)
        
        return modes
    }
}
