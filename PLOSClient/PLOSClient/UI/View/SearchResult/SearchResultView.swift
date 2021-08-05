//
//  SearchResultView.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Resolver
import SwiftUI

struct SearchResultView: View {
    @InjectedObject var viewModel: SearchResultViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.documents) { item in
                    SearchResultRow(document: item)
                }
            }
            .animation(nil)
        }
        .alertError(error: $viewModel.error)
    }
    
    init(text: String) {
        viewModel.text = text
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(text: "DNA")
    }
}
