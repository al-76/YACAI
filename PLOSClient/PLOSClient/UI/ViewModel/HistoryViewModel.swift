//
//  HistoryViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift
import RxCocoa

final class HistoryViewModel: ViewModel {
    struct Input {
        let searchHistory: Driver<String>
        let addHistory: Signal<String>
    }
    
    struct Output {
        let history: Driver<[History]>
        let errors: Signal<Error>
    }
        
    private let searchHistoryUseCase: AnyUseCase<String, [History]>
    private let addHistoryUseCase: AnyUseCase<String, Bool>
    
    init(searchHistoryUseCase: AnyUseCase<String, [History]>,
         addHistoryUseCase: AnyUseCase<String, Bool>) {
        self.searchHistoryUseCase = searchHistoryUseCase
        self.addHistoryUseCase = addHistoryUseCase
    }
    
    func transform(from input: Input) -> Output {
        let errors = PublishRelay<Error>()
        let foundHistory = input.searchHistory
            .flatMapLatest { [weak self] value -> Driver<[History]> in
                guard let self = self else { return .just([]) }
                return self.searchHistoryUseCase.execute(with: value)
                    .asDriver(errors: errors)
            }
        let updatedHistory = input.addHistory
            .filter { !$0.isEmpty }
            .flatMapLatest { [weak self] value -> Driver<Bool> in
                guard let self = self else { return .just(false) }
                return self.addHistoryUseCase.execute(with: value)
                    .asDriver(errors: errors)
            }
            .flatMap { _ in
                foundHistory
            }
        return Output(history: Driver.merge(foundHistory, updatedHistory),
                      errors: errors.asSignal())
    }
    
}
