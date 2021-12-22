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
    
    var body: some View {
        NavigationView {
            VStack {
                DocumentsView(text: viewModel.addHistory)
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
