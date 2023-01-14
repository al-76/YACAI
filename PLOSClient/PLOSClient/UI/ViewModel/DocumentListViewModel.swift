//
//  DocumentListViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Combine
import Foundation

final class DocumentListViewModel: ObservableObject {
    // Input
    @Published var searchDocument: String = ""

    // Output
    @Published private(set) var documents: [Document] = []
    @Published var error: ViewError?

    private let searchDocumentUseCase: any UseCase<String, [Document]>

    init(searchUseCase: some UseCase<String, [Document]>) {
        self.searchDocumentUseCase = searchUseCase

        bindInputToOutput()
    }

    private func bindInputToOutput() {
        $searchDocument
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .compactMap { [weak self] value in
                self?.searchDocumentUseCase.execute(with: value)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<[Document], Never> in
                self?.error = ViewError(error)
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .assign(to: &$documents)
    }
}
