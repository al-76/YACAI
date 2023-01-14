//
//  DocumentsView.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 27.07.2021.
//

import SwiftUI

struct DocumentsView: View {
    @StateObject var viewModel = UIContainer.documentsViewModel()

    var body: some View {
        NavigationStack {
            DocumentList(text: $viewModel.addHistory)
            .navigationTitle("Documents")
        }
        .searchable(text: $viewModel.searchHistory) {
            ForEach(viewModel.history) { item in
                Text(item.id).searchCompletion(item.id)
            }
        }
        .onSubmit(of: .search) {
            viewModel.addHistory = viewModel.searchHistory
        }
        .alertError(error: $viewModel.error)
    }
}


struct DocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = DataContainer.documentsRepository
            .register { FakeDocumentsRepository() }
        let _ = DataContainer.historyRepository
            .register { FakeHistoryRepository() }
        DocumentsView()
    }
}
