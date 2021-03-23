//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit

class InfoOptionCell: UITableViewCell {
    static let reuseId = "\(InfoOptionCell.self)"
    override init(style: CellStyle, reuseIdentifier: String?) { super.init(style: .value1, reuseIdentifier: reuseIdentifier) }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
