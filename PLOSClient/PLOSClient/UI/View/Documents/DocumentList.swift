//
//  DocumentList.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Resolver
import SwiftUI

struct DocumentList: View {
    @Binding var text: String
    @InjectedObject var viewModel: DocumentListViewModel

    var body: some View {
        List {
            ForEach(viewModel.documents) { item in
                DocumentRow(document: item)
            }
        }
        .onChange(of: text) {
            viewModel.searchDocument = $0
        }
        .alertError(error: $viewModel.error)
    }
}

struct DocumentList_Previews: PreviewProvider {
    static var previews: some View {
        DocumentList(text: .constant("DNA"))
    }
}