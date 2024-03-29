//
//  DocumentList.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import SwiftUI

struct DocumentList: View {
    @Binding var text: String
    @StateObject var viewModel = UIContainer.documentListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.documents) { item in
                DocumentRow(document: item)
            }
        }
        .onChange(of: text) {
            viewModel.searchDocument = $0
        }
        .onAppear {
            viewModel.searchDocument = text
        }
        .alertError(error: $viewModel.error)
    }
}

struct DocumentList_Previews: PreviewProvider {
    static var previews: some View {
        let _ = DataContainer.documentsRepository
            .register { FakeDocumentsRepository() }
        DocumentList(text: .constant("DNA"))
    }
}
