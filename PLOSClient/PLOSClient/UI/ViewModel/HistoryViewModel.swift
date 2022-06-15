//
//  HistoryViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

final class HistoryViewModel {
    var history = Binder<[History]>(value: [])
    var error = BinderOpt<Error>(value: nil)
            
    private let searchHistoryUseCase: AnyUseCase<String, [History]>
    private let addHistoryUseCase: AnyUseCase<String, Bool>
        
    init(searchHistoryUseCase: AnyUseCase<String, [History]>,
         addHistoryUseCase: AnyUseCase<String, Bool>) {
        self.searchHistoryUseCase = searchHistoryUseCase
        self.addHistoryUseCase = addHistoryUseCase
    }
    
    func search(history name: String) {
        Task {
            do {
                history.value = try await   searchHistoryUseCase.execute(with: name)
            } catch let error {
                self.error.value = error
            }
        }
    }
    
    func add(history name: String) {
        guard !name.isEmpty else { return }
        
        Task {
            do {
                let added = try await addHistoryUseCase.execute(with: name)
                if added {
                    history.value = try await   searchHistoryUseCase.execute(with: name)
                }
            } catch let error {
                self.error.value = error
            }
        }
    }
}
