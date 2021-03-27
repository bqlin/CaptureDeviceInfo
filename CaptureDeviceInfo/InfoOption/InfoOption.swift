//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation

class InfoOption: InfoOptionRepresentable, Hashable {
    var hasNext: Bool {
        nextPageInfoBuilder != nil
    }
    
    var title: String
    var detail: String?
    
    typealias NextPageInfoBuilder = () -> PageInfo
    var nextPageInfoBuilder: NextPageInfoBuilder?
    
    init(title: String, detail: Displayable? = nil, nextInfosBuilder: NextPageInfoBuilder? = nil) {
        self.title = title
        self.detail = detail?.displayText
        self.nextPageInfoBuilder = nextInfosBuilder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(detail)
    }
    
    static func ==(lhs: InfoOption, rhs: InfoOption) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.detail != rhs.detail {
            return false
        }
        return true
    }
}

class InfoOptionSection {
    let title: String
    var options: [InfoOption]
    
    init(title: String, options: [InfoOption]) {
        self.title = title
        self.options = options
    }
}

class PageInfo {
    var title: String
    var sections: [InfoOptionSection]
    typealias SectionIndexTitlesMap = ([InfoOptionSection]) -> [String]
    var sectionIndexTitlesMap: SectionIndexTitlesMap?
    
    init(title: String, sections: [InfoOptionSection], sectionIndexTitlesMap: SectionIndexTitlesMap? = nil) {
        self.title = title
        self.sections = sections
        self.sectionIndexTitlesMap = sectionIndexTitlesMap
    }
}
