//
//  DocumentsViewController.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import Resolver
import UIKit

class DocumentsViewController: UITableViewController {
    var searchResultsController: HistoryViewController!

    @Injected var viewModel: DocumentsViewModel
    
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeView()
        bindViewModel()
    }
    
    private func customizeView() {
        searchResultsController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController

        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.placeholder = "Type..."
        if #available(iOS 13.0, *) {
            searchController.showsSearchResultsController = true
        }
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesBackButton = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        searchResultsController.searchDocument.bind { [weak self] in
            self?.search(document: $0)
        }
        
        viewModel.documents.bind { [weak self] _ in
            guard let self = self else { return }
            
            self.tableView.reloadData()
            self.searchController.dismiss(animated: true, completion: nil)
        }
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            self?.presentAlertError(error: error)
        }
    }
    
    private func search(document name: String) {
        searchResultsController.addHistory.value = name
        viewModel.search(document: name)
    }
}

extension DocumentsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(document: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultsController.searchHistory.value = searchText
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultsController.searchHistory.value = searchBar.text ?? ""
    }
}

extension DocumentsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.documents.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let documents = viewModel.documents
        let model = documents.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsCell", for: indexPath)
        configureDocumentsCell(document: model, cell: cell)
        return cell
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
