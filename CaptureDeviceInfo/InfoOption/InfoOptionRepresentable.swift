//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation

protocol InfoOptionRepresentable {
    var title: String { get }
    var detail: String { get }
    
    var next: [InfoOptionRepresentable]? {get}
}
