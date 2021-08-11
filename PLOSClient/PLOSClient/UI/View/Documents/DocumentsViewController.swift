//
//  DocumentsViewController.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import Resolver
import RxCocoa
import RxSwift
import UIKit

class DocumentsViewController: UITableViewController {
    var searchResultsController: HistoryViewController!

    @Injected var viewModel: DocumentsViewModel
    
    private var searchController: UISearchController!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeView()
        bindViewModel()
    }
    
    private func customizeView() {
        searchResultsController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController

        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.placeholder = "Type..."
        if #available(iOS 13.0, *) {
            searchController.showsSearchResultsController = true
        }
        navigationItem.searchController = searchController
        navigationItem.hidesBackButton = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        let input = DocumentsViewModel.Input(searchDocument: createSearchDriver())
        let output = viewModel.transform(from: input)
        disposeBag.insert {
            // search
            searchController.searchBar.rx.text
                .asDriver()
                .compactMap { $0 }
                .drive(searchResultsController.searchHistory)
            // documents
            output.documents.drive(tableView.rx
                .items(cellIdentifier: "DocumentsCell")) { [weak self] _, model, cell in
                self?.configureDocumentsCell(document: model, cell: cell)
            }
            // errors
            output.errors.emit(onNext: { [weak self] in
                self?.presentAlertError(error: $0)
            })
        }
    }
    
    private func createSearchDriver() -> Driver<String> {
        let searchBar = searchController.searchBar.rx
            .searchButtonClicked
            .asDriver()
            .map { [weak searchController] in searchController?.searchBar.text }
            .compactMap { $0 }
            .map { [weak searchResultsController] text -> String in
                searchResultsController?.addHistory.accept(text)
                return text
            }
        let searchDocument = searchResultsController.searchDocument
            .map { [weak searchController] text in
                searchController?.searchBar.text = text
                return text
            }
            .asDriver(onErrorJustReturn: "")
        return Driver.merge(searchBar, searchDocument)
            .map { [weak self] text -> String in
                self?.searchController.dismiss(animated: true, completion: nil)
                return text
            }
    }
    
    private func configureDocumentsCell(document: Document, cell: UITableViewCell?) {
        guard let documentCell = cell as? DocumentsViewCell else { return }
        documentCell.setDocument(with: document) { viewController, error in
            if let vc = viewController {
                self.present(vc, animated: true)
            } else if let error = error {
                self.presentAlertError(error: error)
            }
        }
    }
}
