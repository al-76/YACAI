//
//  DocumentsViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

final class DocumentsViewModel<Scheduler: Combine.Scheduler>: ObservableObject {
    // Input
    @Published var searchHistory: String = ""
    @Published var addHistory: String = ""
    
    // Output
    @Published private(set) var history: [History] = []
    @Published var error: ViewError?

    private let searchHistoryUseCase: any UseCase<String, [History]>
    private let addHistoryUseCase: any UseCase<String, Bool>
    private let scheduler: Scheduler
    
    init(searchHistoryUseCase: some UseCase<String, [History]>,
         addHistoryUseCase: some UseCase<String, Bool>,
         scheduler: Scheduler = DispatchQueue.main)
    {
        self.searchHistoryUseCase = searchHistoryUseCase
        self.addHistoryUseCase = addHistoryUseCase
        self.scheduler = scheduler
        
        bindInputToOutput()
    }
    
    private func bindInputToOutput() {
        let foundHistory = $searchHistory
            .compactMap { [weak self] in
                self?.searchHistoryUseCase.execute(with: $0)
            }
            .switchToLatest()

        let updatedHistory = $addHistory
            .filter { !$0.isEmpty }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { [weak self] in
                self?.addHistoryUseCase.execute(with: $0)
            }
            .switchToLatest()
            .flatMap { _ in
                foundHistory
            }
        
        foundHistory.merge(with: updatedHistory)
            .receive(on: DispatchQueue.main)
            .catch { [weak self] in
                self?.error = ViewError($0)
                return Just([History]()).eraseToAnyPublisher()
            }
            .assign(to: &$history)
    }
}
