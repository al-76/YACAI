//
//  SearchResultViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Combine
import Foundation
import Resolver

class SearchResultViewModel: ObservableObject {
    // Input
    @Published var text: String = ""

    // Output
    @Published private(set) var documents: [Document] = []
    @Published var error: ViewError?

    private let searchUseCase: AnyUseCase<String, [Document]>

    init(searchUseCase: AnyUseCase<String, [Document]>) {
        self.searchUseCase = searchUseCase

        bindInputToOutput()
    }

    private func bindInputToOutput() {
        $text.filter { !$0.isEmpty }
            .flatMap { [weak searchUseCase] value in
                searchUseCase?.execute(with: value) ??
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
