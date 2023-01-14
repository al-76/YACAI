//
//  HistoryViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

final class DocumentsViewModel: ObservableObject {
    // Input
    @Published var searchHistory: String = ""
    @Published var addHistory: String = ""
    
    // Output
    @Published private(set) var history: [History] = []
    @Published var error: ViewError?

    private let searchHistoryUseCase: any UseCase<String, [History]>
    private let addHistoryUseCase: any UseCase<String, Bool>
    
    init(searchHistoryUseCase: some UseCase<String, [History]>,
         addHistoryUseCase: some UseCase<String, Bool>)
    {
        self.searchHistoryUseCase = searchHistoryUseCase
        self.addHistoryUseCase = addHistoryUseCase
        
        bindInputToOutput()
    }
    
    private func bindInputToOutput() {
        let foundHistory = $searchHistory
            .compactMap { [weak self] value in
                self?.searchHistoryUseCase.execute(with: value)
            }
            .switchToLatest()

        let updatedHistory = $addHistory
            .filter { !$0.isEmpty }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { [weak self] value in
                self?.addHistoryUseCase.execute(with: value)
            }
            .switchToLatest()
            .flatMap { _ in
                foundHistory
            }
        
        foundHistory.merge(with: updatedHistory)
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<[History], Never> in
                self?.error = ViewError(error)
                return Just([]).eraseToAnyPublisher()
            }
            .assign(to: &$history)
    }
}
