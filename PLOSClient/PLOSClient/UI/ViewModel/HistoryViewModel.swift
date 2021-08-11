//
//  HistoryViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift
import RxCocoa

class HistoryViewModel: ViewModel {
    struct Input {
        let searchHistory: Driver<String>
        let addHistory: Signal<String>
    }
    
    struct Output {
        let history: Driver<[History]>
        let errors: Signal<Error>
    }
        
    private let searchHistoryUseCase: AnyUseCase<String, HistoryResult>
    private let addHistoryUseCase: AnyUseCase<String, BoolResult>
    
    init(searchHistoryUseCase: AnyUseCase<String, HistoryResult>,
         addHistoryUseCase: AnyUseCase<String, BoolResult>) {
        self.searchHistoryUseCase = searchHistoryUseCase
        self.addHistoryUseCase = addHistoryUseCase
    }
    
    func transform(from input: Input) -> Output {
        let errors = PublishRelay<Error>()
        let foundHistory = input.searchHistory
            .flatMapLatest { [weak self] value -> Driver<HistoryResult> in
                guard let self = self else { return .just(.success([])) }
                return self.searchHistoryUseCase.execute(with: value)
                    .asDriver { .just(.failure($0)) }
            }
            .handleResult(from: { $0.getState() }, errors: errors)
        let updatedHistory = input.addHistory
            .filter { !$0.isEmpty }
            .flatMapLatest { [weak self] value -> Driver<BoolResult> in
                guard let self = self else { return .just(.success(false)) }
                return self.addHistoryUseCase.execute(with: value)
                    .asDriver { .just(.failure($0)) }
            }
            .handleResult(from: { $0.getState() }, errors: errors)
            .flatMap { _ in
                foundHistory
            }
        return Output(history: Driver.merge(foundHistory, updatedHistory),
                      errors: errors.asSignal())
    }
    
}
