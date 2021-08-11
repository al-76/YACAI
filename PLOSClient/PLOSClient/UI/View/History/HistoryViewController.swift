//
//  HistoryViewController.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import UIKit
import Resolver
import RxSwift
import RxCocoa

class HistoryViewController: UITableViewController {
    let searchHistory = BehaviorRelay<String>(value: "")
    let addHistory = PublishRelay<String>()
    let searchDocument = PublishRelay<String>()
    
    @Injected var viewModel: HistoryViewModel
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        bindViewModel()
    }
    
    private func customizeView() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }

    private func bindViewModel() {
        let handleSelectedItem: ((IndexPath) -> String) = { [weak self] index in
            (self?.getSelectedItem(index)) ?? ""
        }
        let input = HistoryViewModel.Input(searchHistory: searchHistory.asDriver(),
                                           addHistory: addHistory.asSignal())
        let output = viewModel.transform(from: input)
        disposeBag.insert {
            // history
            output.history.drive(tableView.rx
                                    .items(cellIdentifier: "HistoryCell")) { row, model, cell in
                if let historyCell = cell as? HistoryViewCell {
                    historyCell.setHistory(with: model)
                }
            }
            // errors
            output.errors.emit(onNext: { [weak self] in
                self?.presentAlertError(error: $0)
            })
            // selected history
            tableView.rx.itemSelected
                .map { handleSelectedItem($0) }
                .bind(to: searchDocument)
        }
    }
    
    private func getSelectedItem(_ index: IndexPath) -> String {
        guard let cell = tableView.cellForRow(at: index) as? HistoryViewCell,
              let text = cell.history.text else { return "" }
        return text
    }
}
