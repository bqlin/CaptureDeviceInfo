//
// Created by Bq Lin on 2021/3/23.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit

protocol InfoOptionViewModelDelegate: class {
    func viewModel(_ viewModel: InfoOptionViewModel, didSelectRow item: InfoOption)
}

class InfoOptionViewModel: NSObject {
    var info: InfoOption!
    var sections = [InfoOptionSection]()
    var title = ""
    weak var delegate: InfoOptionViewModelDelegate?
    
    func setupData() {
        guard let builder = info.nextPageInfoBuilder, let current: PageInfo = builder() else {
            return
        }
        
        sections = current.sections
        title = current.title
    }
}

extension InfoOptionViewModel: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoOptionCell.reuseId, for: indexPath) as! InfoOptionCell
        let info = sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = info.title
        cell.detailTextLabel?.text = info.detail
        cell.accessoryType = info.nextPageInfoBuilder == nil ? .none : .disclosureIndicator
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionItem = sections[section]
        return sectionItem.title
    }
}

extension InfoOptionViewModel: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = sections[indexPath.section].options[indexPath.row]
        guard info.nextPageInfoBuilder != nil else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        delegate?.viewModel(self, didSelectRow: info)
    }
}
