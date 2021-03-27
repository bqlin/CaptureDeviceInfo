//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit

protocol InfoOptionViewModelDelegate: class {
    func viewModel(_ viewModel: InfoOptionViewModel, didSelectRow item: InfoOption)
    func viewModelDataDidLoad(_ viewModel: InfoOptionViewModel)
}

class InfoOptionViewModel: NSObject {
    var formInfo: InfoOption!
    var pageInfo: PageInfo!
    weak var delegate: InfoOptionViewModelDelegate?
    
    func setupData() {
        guard let builder = formInfo.nextPageInfoBuilder else {
            return
        }
        pageInfo = builder()
        
        delegate?.viewModelDataDidLoad(self)
    }
}

extension InfoOptionViewModel: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { pageInfo.sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pageInfo.sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoOptionCell.reuseId, for: indexPath) as! InfoOptionCell
        let info = pageInfo.sections[indexPath.section].options[indexPath.row]
        cell.setup(representable: info)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = pageInfo.sections[section]
        return sectionItem.title
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard let titleMap = pageInfo.sectionIndexTitlesMap else {
            return nil
        }
        
        return titleMap(pageInfo.sections)
    }
}

extension InfoOptionViewModel: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = pageInfo.sections[indexPath.section].options[indexPath.row]
        guard info.nextPageInfoBuilder != nil else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        delegate?.viewModel(self, didSelectRow: info)
    }
}
