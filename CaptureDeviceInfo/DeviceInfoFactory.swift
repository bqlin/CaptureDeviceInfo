//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation
import AVFoundation

class DeviceInfoFactory {
    static let `default` = DeviceInfoFactory()
    
    var allDevices = [AVCaptureDevice]()
    
    func updateAllDevices() {
        allDevices = DeviceRepository.allCaptureDevices()
    }
    
    func positionPageInfo() -> PageInfo {
        var positions = [AVCaptureDevice.Position]()
        for device in allDevices {
            positions.append(device.position)
        }
        positions = positions.removeDuplicate()
        
        var remainDevices = allDevices
        var sections = [InfoOptionSection]()
        for position in positions {
            var options = [InfoOption]()
            for device in remainDevices {
                guard device.position == position else {
                    continue
                }
                
                let info = InfoOption(title: device.localizedName) {
                    self.deviceDetailPageInfo(device: device)
                }
                options.append(info)
                remainDevices.remove(at: remainDevices.firstIndex(of: device)!)
            }
            sections.append(InfoOptionSection(title: position.displayText, options: options))
        }
        
        return PageInfo(title: "Capture Devices", sections: sections)
    }
    
    func deviceDetailPageInfo(device: AVCaptureDevice) -> PageInfo {
        var sections = [InfoOptionSection]()
        sections += [
            buildBasicInfoSection(device: device),
            buildMediaTypeSection(device: device),
        ]
        if (device.hasMediaType(.video)) {
            sections += [
                buildExposureSection(device: device),
                buildDepthDataSection(device: device),
                buildZoomSection(device: device),
                buildFocusSection(device: device),
                buildFlashSection(device: device),
                buildTorchSection(device: device),
                buildLowLightSection(device: device),
            ]
        }
        
        return PageInfo(title: device.localizedName, sections: sections)
    }
    
    func buildMediaTypeSection(device: AVCaptureDevice) -> InfoOptionSection {
        let options = DeviceRepository.allMediaTypes(device: device).map { mediaType in
            InfoOption(title: mediaType.displayText)
        }
        
        return InfoOptionSection(title: "Media Type", options: options)
    }
    
    func buildBasicInfoSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        addOption("unique ID", device.uniqueID)
        addOption("model ID", device.modelID)
        addOption("localizedName", device.localizedName)
        addOption("device type", device.deviceType)
        // TODO: constituentDevices
        
        if device.hasMediaType(.video) {
        addOption("lens diaphragm", "\(device.lensAperture)")
            if (device.formats.count > 0) {
                options.append(InfoOption(title: "formats") {
                    self.buildFormatPage(device: device)
                })
            }
            addOption("active video frame duration", "\(device.activeVideoMinFrameDuration.seconds)~\(device.activeVideoMaxFrameDuration.seconds)")
            addOption("white balance mode supported", DeviceRepository.allWhiteBalanceModeSupported(device: device))
        }
    
    
        return InfoOptionSection(title: "Basic Info", options: options)
    }
    
    func buildFormatPage(device: AVCaptureDevice) -> PageInfo {
        var activeIndex = -1
        var sections: [InfoOptionSection] = device.formats.enumerated().map { (i, format) -> InfoOptionSection in
            var title = "#\(i)"
            if format == device.activeFormat {
                title += " - active"
                activeIndex = i
            }
            return buildFormatSection(format: format, title: title)
        }
        var merged = false
        mergeCommonSection(&sections, merged: &merged)
        
        return PageInfo(title: "formats", sections: sections) { sections in
            sections.enumerated().map { i, section in
                if merged && i == 0 {
                    return "c"
                }
    
                let index = merged ? i - 1 : i
                if activeIndex == index {
                    return "★"
                }
                
                return String(format: "%02d", index)
            }
        }
    }
    
    func mergeCommonSection(_ sections: inout [InfoOptionSection], merged: inout Bool) {
        let commonSection = InfoOptionSection(title: "common", options: [])
        var diffIndies = Set<Int>()
        
        guard sections.count > 0, sections.first!.options.count > 0 else {
            return
        }
        let optionCount = sections.first!.options.count
        for i in 0 ..< optionCount {
            let tmpOption = sections.first!.options[i]
            var diff = false
            
            for section in sections {
                if tmpOption != section.options[i] {
                    diff = true
                    break;
                }
            }
            
            if diff {
                diffIndies.insert(i)
            }
        }
        let commonIndies = Array(0 ..< optionCount).filter { e in
            !diffIndies.contains(e)
        }
        
        for i in 0 ..< commonIndies.count {
            let index = commonIndies[i] - i
            let firstSection = sections.first!
            commonSection.options.append(firstSection.options[index])
            
            sections.forEach { section in
                section.options.remove(at: index)
            }
        }
        
        if commonIndies.count > 0 {
            sections.insert(commonSection, at: 0)
            merged = true
        }
    }
    
    func buildFormatSection(format: AVCaptureDevice.Format, title: String) -> InfoOptionSection {
        var options = [InfoOption]()
        
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        
        addOption("mediaType", format.mediaType)
        addOption("video HDR supported", format.isVideoHDRSupported)
        addOption("unsupported capture output classes", format.unsupportedCaptureOutputClasses)
        addOption("highest resolution still image", format.highResolutionStillImageDimensions)
        addOption("exposure duration", "\(format.minExposureDuration.seconds)~\(format.maxExposureDuration.seconds)")
        addOption("ISO", "\(format.minISO)~\(format.maxISO)")
        addOption("autofocus system", format.autoFocusSystem)
        addOption("video field of view", "\(format.videoFieldOfView)")
        addOption("video max zoom factor", "\(format.videoMaxZoomFactor)")
        addOption("video zoom factor upscale threshold", "\(format.videoZoomFactorUpscaleThreshold)")
        addOption("video binned", format.isVideoBinned)
        if #available(iOS 13.0, *) {
            addOption("multiCam supported", format.isMultiCamSupported)
            addOption("highest photo quality supported", format.isHighestPhotoQualitySupported)
        } else {
            addOption("multiCam supported", false)
            addOption("highest photo quality supported", false)
        }
        addOption("video supported frame rate ranges", format.videoSupportedFrameRateRanges)
        if #available(iOS 13.0, *) {
            addOption("geometric distortion corrected video field of view", "\(format.geometricDistortionCorrectedVideoFieldOfView)")
            addOption("global tone mapping supported", format.isGlobalToneMappingSupported)
        } else {
            addOption("global tone mapping supported", false)
        }
        addOption("supported depth data formats", format.supportedDepthDataFormats)
        if #available(iOS 12.0, *) {
            addOption("portrait effects matte still image delivery supported", format.isPortraitEffectsMatteStillImageDeliverySupported)
        } else {
            // Fallback on earlier versions
        }
        addOption("video min zoom factor for depth data delivery", "\(format.videoMinZoomFactorForDepthDataDelivery)")
        addOption("supported color spaces", format.supportedColorSpaces)
        
        return InfoOptionSection(title: title, options: options)
    }
    
    func buildExposureSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
        
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        
        addOption("exposure duration", "\(device.exposureDuration.seconds)")
        addOption("exposure target offset", "\(device.exposureTargetOffset)")
        addOption("exposure target bias", "\(device.exposureTargetBias)")
        addOption("exposure target bias range", "\(device.minExposureTargetBias)~\(device.maxExposureTargetBias)")
        if #available(iOS 12.0, *) {
            addOption("active max exposure duration", "\(device.activeMaxExposureDuration.seconds)")
        } else {
            // Fallback on earlier versions
        }
        addOption("exposure mode supported", DeviceRepository.allExposureMode(device: device))
        addOption("exposure point of interest", "\(device.exposurePointOfInterest)")
        addOption("is exposure point of interest supported", device.isExposurePointOfInterestSupported)
        
        return InfoOptionSection(title: "Exposure", options: options)
    }
    
    func buildDepthDataSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
        
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
    
        let activeDepthDataFormat: Any = device.activeDepthDataFormat ?? []
        addOption("active depth data format", "\(activeDepthDataFormat)")
        if #available(iOS 12.0, *) {
            addOption("active depth data min frame duration", "\(device.activeDepthDataMinFrameDuration.seconds)")
        } else {
            // Fallback on earlier versions
        }
        
        return InfoOptionSection(title: "Depth Data", options: options)
    }
    
    func buildZoomSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
        
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        
        addOption("video zoom factor", "\(device.videoZoomFactor)")
        addOption("video zoom factor range", "\(device.minAvailableVideoZoomFactor)~\(device.maxAvailableVideoZoomFactor)")
        if #available(iOS 13.0, *) {
            addOption("virtual device switch over video zoom factors", device.virtualDeviceSwitchOverVideoZoomFactors)
        } else {
            // Fallback on earlier versions
        }
        
        return InfoOptionSection(title: "Zoom", options: options)
    }
    
    func buildFocusSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
        
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        
        addOption("focus mode supported", DeviceRepository.allFocusModeSupported(device: device))
        addOption("focus point of interest", "\(device.focusPointOfInterest)")
        addOption("focus point of interest supported", device.isFocusPointOfInterestSupported)
        addOption("smooth auto focus enabled", device.isSmoothAutoFocusEnabled)
        addOption("Smooth Auto Focus Supported", device.isSmoothAutoFocusSupported)
        addOption("auto focus range restriction", device.autoFocusRangeRestriction)
        
        return InfoOptionSection(title: "Focus", options: options)
    }
    
    func buildFlashSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
    
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        addOption("has flash", device.hasFlash)
        addOption("flash available", device.isFlashAvailable)
        addOption("flash mode supported", DeviceRepository.allFlashModeSupported(device: device))
    
        return InfoOptionSection(title: "Flash", options: options)
    }
    
    func buildTorchSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
    
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        addOption("has torch", device.hasTorch)
        addOption("torch available", device.isTorchAvailable)
        addOption("torch level", "\(device.torchLevel)")
        addOption("max available torch level", "\(AVCaptureDevice.maxAvailableTorchLevel)")
        addOption("torch mode supported", DeviceRepository.allTorchModeSupported(device: device))
    
        return InfoOptionSection(title: "Torch", options: options)
    }
    
    func buildLowLightSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
    
        func addOption(_ title: String, _ detail: Displayable? = nil) {
            options.append(InfoOption(title: title, detail: detail))
        }
        addOption("low light boost supported", device.isLowLightBoostSupported)
        addOption("automatically enables low light boost when available", device.automaticallyEnablesLowLightBoostWhenAvailable)
    
        return InfoOptionSection(title: "Low Light", options: options)
    }
    
}
