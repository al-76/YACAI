//
//  HistoryViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation
import Resolver

class HistoryViewModel: ObservableObject {
    // Input
    @Published var searchHistory: String = ""
    @Published var addHistory: String = ""
    
    // Output
    @Published private(set) var history: [History] = []
    @Published var error: ViewError?

    private let searchHistoryUseCase: AnyUseCase<String, [History]>
    private let addHistoryUseCase: AnyUseCase<String, Bool>
    
    init(searchHistoryUseCase: AnyUseCase<String, [History]>,
         addHistoryUseCase: AnyUseCase<String, Bool>)
    {
        self.searchHistoryUseCase = searchHistoryUseCase
        self.addHistoryUseCase = addHistoryUseCase
        
        bindInputToOutput()
    }
    
    private func bindInputToOutput() {
        let foundHistory = $searchHistory
            .flatMap { [weak self] value in
                self?.searchHistoryUseCase.execute(with: value) ??
                    Just([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        let updatedHistory = $addHistory
            .filter { !$0.isEmpty }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .flatMap { [weak self] value in
                self?.addHistoryUseCase.execute(with: value) ??
                    Just(false)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
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
