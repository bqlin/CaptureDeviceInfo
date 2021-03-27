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
        sections.append(buildBasicInfoSection(device: device))
        sections.append(buildMediaTypeSection(device: device))
        
        return PageInfo(title: device.localizedName, sections: sections)
    }
    
    func buildMediaTypeSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = DeviceRepository.allMediaTypes(device: device).map { mediaType in
            InfoOption(title: mediaType.displayText)
        }
        
        return InfoOptionSection(title: "Media Type", options: options)
    }
    
    func buildBasicInfoSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
        options.append(InfoOption(title: "unique ID", detail: device.uniqueID))
        options.append(InfoOption(title: "model ID", detail: device.modelID))
        options.append(InfoOption(title: "localizedName", detail: device.localizedName))
        options.append(InfoOption(title: "device type", detail: device.deviceType.rawValue))
        // TODO: constituentDevices
        options.append(InfoOption(title: "lens diaphragm", detail: "\(device.lensAperture)"))
        options.append(InfoOption(title: "formats", detail: "\(device.activeFormat)") {
            self.buildFormatPage(device: device)
        })
        
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
                
                var index = merged ? i - 1 : i
                if activeIndex == index {
                    return "★"
                }
                
                return String(format: "%02d", index)
            }
        }
    }
    
    func mergeCommonSection(_ sections: inout [InfoOptionSection], merged: inout Bool) {
        var commonSection = InfoOptionSection(title: "common", options: [])
        var diffIndies = Set<Int>()
        
        let optionCount = sections.first!.options.count
        for i in 0 ..< optionCount {
            var tmpOption = sections.first!.options[i]
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
        
        return InfoOptionSection(title: title, options: options)
    }
}
