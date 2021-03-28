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
        
        viewModel.delegate = self
        viewModel.setupData()
        self.title = viewModel.pageInfo.title
        infoOptionView.tableView.dataSource = viewModel
        infoOptionView.tableView.delegate = viewModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPaths = infoOptionView.tableView.indexPathsForSelectedRows {
            indexPaths.forEach { indexPath in
                infoOptionView.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension InfoOptionViewController: InfoOptionViewModelDelegate {
    func viewModelDataDidLoad(_ viewModel: InfoOptionViewModel) {
        infoOptionView.tableView.reloadData()
    }
    
    func viewModel(_ viewModel: InfoOptionViewModel, didSelectRow item: InfoOption) {
        let controller = InfoOptionViewController()
        controller.viewModel.formInfo = item
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
