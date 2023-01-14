//
//  DocumentListViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Combine
import Foundation

final class DocumentListViewModel<Scheduler: Combine.Scheduler>: ObservableObject {
    // Input
    @Published var searchDocument: String = ""

    // Output
    @Published private(set) var documents: [Document] = []
    @Published var error: ViewError?

    private let searchDocumentUseCase: any UseCase<String, [Document]>
    private let scheduler: Scheduler

    init(searchUseCase: some UseCase<String, [Document]>,
         scheduler: Scheduler = DispatchQueue.main) {
        self.searchDocumentUseCase = searchUseCase
        self.scheduler = scheduler

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
            .receive(on: scheduler)
            .catch { [weak self] in
                self?.error = ViewError($0)
                return Just([Document]()).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .assign(to: &$documents)
    }
}
