//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation

class InfoOption {
    var title: String
    var detail: String?
    
    typealias NextPageInfoBuilder = () -> PageInfo
    var nextPageInfoBuilder: NextPageInfoBuilder?
    
    init(title: String, detail: String? = nil, nextInfosBuilder: NextPageInfoBuilder? = nil) {
        self.title = title
        self.detail = detail
        self.nextPageInfoBuilder = nextInfosBuilder
    }
    
    init(title: String, detail: String? = nil) {
        self.title = title
        self.detail = detail
    }
}

class InfoOptionSection {
    let title: String
    let options: [InfoOption]
    
    init(title: String, options: [InfoOption]) {
        self.title = title
        self.options = options
    }
}

class PageInfo {
    var title: String
    var sections: [InfoOptionSection]
    
    init(title: String, sections: [InfoOptionSection]) {
        self.title = title
        self.sections = sections
    }
}
