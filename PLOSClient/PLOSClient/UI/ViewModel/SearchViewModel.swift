//
//  SearchViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation
import Resolver

class SearchViewModel: ObservableObject {
    // Input
    @Published var text: String = ""
    @Published var historyText: String = ""
    
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
        let foundHistory = $text
            .flatMap { [searchHistoryUseCase] value in
                searchHistoryUseCase.execute(with: value)
            }
        let updatedHistory = $historyText
            .filter { !$0.isEmpty }
            .flatMap { [addHistoryUseCase] value in
                addHistoryUseCase.execute(with: value)
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
