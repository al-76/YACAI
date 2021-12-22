//
//  DocumentsView.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Resolver
import SwiftUI

struct DocumentsView: View {
    @InjectedObject var viewModel: DocumentsViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.documents) { item in
                    DocumentRow(document: item)
                }
            }
        }
        .alertError(error: $viewModel.error)
    }
    
    init(text: String) {
        viewModel.searchDocument = text
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsView(text: "DNA")
    }
}
