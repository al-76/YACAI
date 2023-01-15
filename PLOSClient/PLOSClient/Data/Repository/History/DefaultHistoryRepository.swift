//
//  DefaultHistoryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import Foundation

final class DefaultHistoryRepository: HistoryRepository {
    private let storage: any Storage<History>
    
    init(storage: some Storage<History>) {
        self.storage = storage
    }

    func read() -> AnyPublisher<[History], Error> {
        storage.load()
    }

    func write(item: History) -> AnyPublisher<Bool, Error> {
        storage.save(item: item)
    }
}
