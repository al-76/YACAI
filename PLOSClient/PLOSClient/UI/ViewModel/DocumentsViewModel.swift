//
//  DocumentsViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift
import RxCocoa

class DocumentsViewModel: ViewModel {
    struct Input {
        let searchDocument: Driver<String>
    }
    
    struct Output {
        let documents: Driver<[Document]>
        let errors: Signal<Error>
    }
    
    private let searchUseCase: AnyUseCase<String, [Document]>
    
    init(searchUseCase: AnyUseCase<String, [Document]>) {
        self.searchUseCase = searchUseCase
    }
    
    func transform(from input: Input) -> Output {
        let errors = PublishRelay<Error>()
        let documents = input.searchDocument
            .flatMapLatest { [weak self] value -> Driver<[Document]> in
                guard let self = self else { return .just([]) }
                return self.searchUseCase.execute(with: value)
                    .asDriver(errors: errors)
            }
        return Output(documents: documents, errors: errors.asSignal())
    }
}
