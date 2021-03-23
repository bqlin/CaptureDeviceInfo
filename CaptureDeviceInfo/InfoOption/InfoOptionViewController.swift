//
//  InfoOptionViewController.swift
//  CaptureDeviceInfo
//
//  Created by Bq Lin on 2021/3/23.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

class InfoOptionViewController: UIViewController {
    override func loadView() {
        super.loadView()
        view = InfoOptionView()
    }
    
    var infoOptionView: InfoOptionView {
        view as! InfoOptionView
    }
    
    let viewModel = InfoOptionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        viewModel.setupData()
        viewModel.delegate = self
        self.title = viewModel.title
        infoOptionView.tableView.dataSource = viewModel
        infoOptionView.tableView.delegate = viewModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension InfoOptionViewController: InfoOptionViewModelDelegate {
    func viewModel(_ viewModel: InfoOptionViewModel, didSelectRow item: InfoOption) {
        let controller = InfoOptionViewController()
        controller.viewModel.info = item
    
        print(#function)
        navigationController?.pushViewController(controller, animated: true)
    }
}
