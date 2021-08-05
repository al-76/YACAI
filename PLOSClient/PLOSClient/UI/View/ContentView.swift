//
//  ContentView.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 27.07.2021.
//

import SwiftUI
import Resolver

struct ContentView: View {
    @InjectedObject var viewModel: SearchViewModel
    @State private var search = false

    var body: some View {
        NavigationView {
            VStack {
                if search { // Show search results
                    SearchResultView(text: viewModel.text)
                } else { // Show history as suggestions
                    List {
                        ForEach(viewModel.history) { item in
                            Button(item.id) {
                                viewModel.text = item.id
                                search = true
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Search")
            .navigationBarSearch($viewModel.text,
                                 placeholder: "Type...",
                                 cancelClicked: { search = false },
                                 searchClicked: {
                                    viewModel.historyText = viewModel.text
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
