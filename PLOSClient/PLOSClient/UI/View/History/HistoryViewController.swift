//
//  HistoryViewController.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import UIKit
import Resolver

final class HistoryViewController: UITableViewController {
    // Internal bindings
    var addHistory = Binder<String>(value: "")
    var searchHistory = Binder<String>(value: "")
    
    // External bindings
    var searchDocument = Binder<String>(value: "")
    
    @Injected var viewModel: HistoryViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        bindViewModel()
    }
    
    private func customizeView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }

    private func bindViewModel() {
        searchHistory.bind { [weak self] in
            self?.viewModel.search(history: $0)
        }
        addHistory.bind { [weak self] in
            self?.viewModel.add(history: $0)
        }
        viewModel.history.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            self?.presentAlertError(error: error)
        }
    }
}

extension HistoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchDocument.value = getSelectedItem(indexPath)
    }
    
    private func getSelectedItem(_ index: IndexPath) -> String {
        guard let cell = tableView.cellForRow(at: index) as? HistoryViewCell,
              let text = cell.history.text else { return "" }
        return text
    }
}

extension HistoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.history.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.history.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        if let historyCell = cell as? HistoryViewCell {
            historyCell.setHistory(with: model)
        }
        return cell
    }
}
