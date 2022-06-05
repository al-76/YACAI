//
//  CommandRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import Foundation

protocol CommandRepository {
    associatedtype T

    func add(item: T) -> AnyPublisher<Bool, Error>
}

struct AnyCommandRepository<T>: CommandRepository {
    private let addObject: (T) -> AnyPublisher<Bool, Error>

    init<TypeUseCase: CommandRepository>(wrapped: TypeUseCase)
        where TypeUseCase.T == T {
        addObject = wrapped.add
    }

    func add(item: T) -> AnyPublisher<Bool, Error> {
        addObject(item)
    }
}

