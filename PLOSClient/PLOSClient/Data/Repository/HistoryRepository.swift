//
//  HistoryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import Foundation

final class HistoryRepository: CommandRepository, QueryRepository {
    private static let history = "history"
    
    private let storage: Storage
    private lazy var data: [History] = {
        self.storage.get(id: Self.history, defaultObject: [T]())
    }()
    
    init(storage: Storage) {
        self.storage = storage
    }

    func add(item: History) -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success(false))
                return
            }
            var added = false
            if !self.data.contains(item) {
                self.data.append(item)
                do {
                    try self.saveData()
                } catch {
                    promise(.failure(error))
                    return
                }
                added = true
            }
            promise(.success((added)))
        }.eraseToAnyPublisher()
    }

    func read(query: String) -> AnyPublisher<[History], Error> {
        Future { [weak self] promise in
            let res = self?.data
                .filter { query.isEmpty || $0.id.contains(query) }
            promise(.success(res ?? []))
        }.eraseToAnyPublisher()
    }
    
    private func saveData() throws {
        try storage.save(id: Self.history, object: data)
    }
}
