//
//  DocumentsViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Combine
import Foundation
import Resolver

class DocumentsViewModel: ObservableObject {
    // Input
    @Published var searchDocument: String = ""

    // Output
    @Published private(set) var documents: [Document] = []
    @Published var error: ViewError?

    private let searchDocumentUseCase: AnyUseCase<String, [Document]>

    init(searchUseCase: AnyUseCase<String, [Document]>) {
        self.searchDocumentUseCase = searchUseCase

        bindInputToOutput()
    }

    private func bindInputToOutput() {
        $searchDocument
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .flatMap { [weak self] value in
                self?.searchDocumentUseCase.execute(with: value) ??
                    Just([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<[Document], Never> in
                self?.error = ViewError(error)
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .assign(to: &$documents)
    }
}
