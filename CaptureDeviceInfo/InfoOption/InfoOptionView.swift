//
//  InfoOptionView.swift
//  CaptureDeviceInfo
//
//  Created by Bq Lin on 2021/3/23.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

class InfoOptionView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.sectionHeaderHeight = 38
        tableView.sectionIndexTrackingBackgroundColor = .cyan
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        tableView.register(InfoOptionCell.self, forCellReuseIdentifier: InfoOptionCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
