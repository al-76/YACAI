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
    @Binding var noDocuments: Bool

    var body: some View {
        VStack {
            if !noDocuments {
                List {
                    ForEach(viewModel.documents) { item in
                        DocumentRow(document: item)
                    }
                }
            }
        }
        .onChange(of: viewModel.documents) { noDocuments = $0.isEmpty }
        .alertError(error: $viewModel.error)
    }
    
    func search(text: String) -> some View {
        viewModel.searchDocument = text
        return self
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsView(noDocuments: .constant(false))
            .search(text: "DNA")
    }
}
