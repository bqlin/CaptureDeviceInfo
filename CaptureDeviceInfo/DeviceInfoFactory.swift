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
            for (i, device) in remainDevices.enumerated() {
                guard device.position == position else {
                    continue
                }
                
                let info = InfoOption(title: device.modelID) {
                    self.deviceDetailPageInfo(device: device)
                }
                options.append(info)
                remainDevices.remove(at: i)
            }
            sections.append(InfoOptionSection(title: position.displayName, options: options))
        }
        
        return PageInfo(title: "Devices", sections: sections)
    }
    
    func deviceDetailPageInfo(device: AVCaptureDevice) -> PageInfo {
        var sections = [InfoOptionSection]()
        sections.append(buildBasicInfoSection(device: device))
        sections.append(buildMediaTypeSection(device: device))
        
        return PageInfo(title: device.localizedName, sections: sections)
    }
    
    func buildMediaTypeSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = DeviceRepository.allMediaTypes(device: device).map { mediaType in
            InfoOption(title: mediaType.displayName)
        }
        
        return InfoOptionSection(title: "Media Type", options: options)
    }
    
    func buildBasicInfoSection(device: AVCaptureDevice) -> InfoOptionSection {
        var options = [InfoOption]()
        options.append(InfoOption(title: "unique ID", detail: device.uniqueID))
        options.append(InfoOption(title: "model ID", detail: device.modelID))
        options.append(InfoOption(title: "localizedName", detail: device.localizedName))
        options.append(InfoOption(title: "Device Type", detail: device.deviceType.rawValue))
        // TODO: constituentDevices
        options.append(InfoOption(title: "lens diaphragm", detail: "\(device.lensAperture)"))
        options.append(InfoOption(title: "formats", detail: "\(device.activeFormat)") {
            self.buildFormatPage(formats: device)
        })
        
        return InfoOptionSection(title: "Basic Info", options: options)
    }
    
    func buildFormatPage(device: AVCaptureDevice) -> PageInfo {
        var sections = [InfoOptionSection]()
        
        return PageInfo(title: "formats", sections: sections)
    }
}
