//
//  DocumentsView.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 27.07.2021.
//

import SwiftUI
import Resolver

struct DocumentsView: View {
    @InjectedObject var viewModel: DocumentsViewModel

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
        DocumentsView()
    }
}
