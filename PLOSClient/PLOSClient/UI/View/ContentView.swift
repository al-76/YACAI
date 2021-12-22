//
//  ContentView.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 27.07.2021.
//

import SwiftUI
import Resolver

struct ContentView: View {
    @InjectedObject var viewModel: HistoryViewModel
    @State private var noDocuments = true
    
    var body: some View {
        NavigationView {
            VStack {
                DocumentsView(noDocuments: $noDocuments)
                    .search(text: viewModel.addHistory)
                if noDocuments {
                    List {
                        ForEach(viewModel.history) { item in
                            Button(item.id) {
                                viewModel.searchHistory = item.id
                                viewModel.addHistory = viewModel.searchHistory
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchHistory) {
                ForEach(viewModel.history) { item in
                    Text(item.id).searchCompletion(item.id)
                }
            }
            .navigationTitle("Search")
            .onSubmit(of: .search) {
                viewModel.addHistory = viewModel.searchHistory
            }
        }
        .alertError(error: $viewModel.error)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
