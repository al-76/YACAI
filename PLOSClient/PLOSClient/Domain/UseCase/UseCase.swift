//
//  UseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift

protocol UseCase {
    associatedtype Input
    associatedtype Output

    func execute(with input: Input) -> Observable<Output>
}

class AnyUseCase<Input, Output>: UseCase {
    private let executeObject: (_ input: Input) -> Observable<Output>

    init<TypeUseCase: UseCase>(wrapped: TypeUseCase)
        where TypeUseCase.Input == Input, TypeUseCase.Output == Output {
        executeObject = wrapped.execute
    }

    func execute(with input: Input) -> Observable<Output> {
        executeObject(input)
    }
}
