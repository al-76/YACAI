//
//  QueryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import Foundation

protocol QueryRepository {
    associatedtype T

    func read(query: String) -> AnyPublisher<[T], Error>
}

class AnyQueryRepository<T>: QueryRepository {
    private let readObject: (String) -> AnyPublisher<[T], Error>

    init<TypeQueryRepository: QueryRepository>(wrapped: TypeQueryRepository)
        where TypeQueryRepository.T == T {
        readObject = wrapped.read
    }

    func read(query: String) -> AnyPublisher<[T], Error> {
        readObject(query)
    }
}
