//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit

class InfoOptionCell: UITableViewCell {
    static let reuseId = "\(InfoOptionCell.self)"
    
    private let titleLabel: UILabel
    private let detailLabel: UILabel
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel()
        detailLabel = UILabel()
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            setupLabel(titleLabel, color: .label)
            setupLabel(detailLabel, color: .secondaryLabel)
        } else {
            setupLabel(titleLabel, color: .darkText)
            setupLabel(detailLabel, color: .darkGray)
        }
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        
        titleLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 1/3),
            
            detailLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 26),
            detailLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            // detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    private func setupLabel(_ label: UILabel, color: UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(representable: InfoOptionRepresentable) {
        titleLabel.text = representable.title
        detailLabel.text = representable.detail
        accessoryType = representable.hasNext ? .disclosureIndicator : .none
    }
}
