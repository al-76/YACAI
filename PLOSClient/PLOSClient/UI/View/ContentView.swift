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
    @State private var search = false

    var body: some View {
        NavigationView {
            VStack {
                if search { // Show search results
                    HistoryView(text: viewModel.searchHistory)
                } else { // Show history as suggestions
                    List {
                        ForEach(viewModel.history) { item in
                            Button(item.id) {
                                viewModel.searchHistory = item.id
                                search = true
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Search")
            .navigationBarSearch($viewModel.searchHistory,
                                 placeholder: "Type...",
                                 hidesSearchBarWhenScrolling: false,
                                 cancelClicked: { search = false },
                                 searchClicked: {
                                    viewModel.addHistory = viewModel.searchHistory
                                    search = true
                                 },
                                 searchDidBegin: { search = false },
                                 textDidChange: { search = false })
            .animation(.default)
        }
        .alertError(error: $viewModel.error)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
