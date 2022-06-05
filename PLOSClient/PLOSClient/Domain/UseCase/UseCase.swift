//
//  UseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

protocol UseCase {
    associatedtype Input
    associatedtype Output

    func execute(with input: Input) -> AnyPublisher<Output, Error>
}

struct AnyUseCase<Input, Output>: UseCase {
    private let executeObject: (_ input: Input) -> AnyPublisher<Output, Error>

    init<TypeUseCase: UseCase>(wrapped: TypeUseCase)
        where TypeUseCase.Input == Input, TypeUseCase.Output == Output {
        executeObject = wrapped.execute
    }

    func execute(with input: Input) -> AnyPublisher<Output, Error> {
        executeObject(input)
    }
}
