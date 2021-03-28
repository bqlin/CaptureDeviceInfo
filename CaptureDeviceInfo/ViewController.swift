//
//  ViewController.swift
//  CaptureDeviceInfo
//
//  Created by Bq Lin on 2021/3/23.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // dump(AVCaptureDevice.devices(), name: "AVCaptureDevice.devices")
        // print("类名：\(InfoOptionCell.reuseId)")
        
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
        // let session = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: nil, position: .unspecified)
        // dump(session.devices, name: "discovery device")
        
        // session.devices.forEach { device in
        //     print("device: \(device), mediaTypes: \(DeviceRepository.allMediaTypes(device: device).map { $0.displayName })")
        // }
        
        // if #available(iOS 13.0, *) {
        //     dump(session.supportedMultiCamDeviceSets, name: "supportedMultiCamDeviceSets")
        // } else {15
        //     // Fallback on earlier versions
        // }
        
        let factory = DeviceInfoFactory.default
        factory.updateAllDevices()
        // dump(factory.positionInfos(), name: "positionInfos")
    }
    
    var infoViewController = InfoOptionViewController()
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        let factory = DeviceInfoFactory.default
        infoViewController.viewModel.formInfo = InfoOption(title: "First", nextInfosBuilder: factory.positionPageInfo)
        navigationController?.pushViewController(infoViewController, animated: true)
    }
}

