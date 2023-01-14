//
//  DefaultHistoryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import Foundation

final class DefaultHistoryRepository: HistoryRepository {
    private static let history = "history"
    
    private let storage: Storage
    private lazy var data: [History] = {
        self.storage.get(id: Self.history, defaultObject: [History]())
    }()
    
    init(storage: Storage) {
        self.storage = storage
    }

    func read() -> AnyPublisher<[History], Error> {
        Future { [weak self] promise in
            promise(.success(self?.data ?? []))
        }.eraseToAnyPublisher()
    }

    func write(item: History) -> AnyPublisher<Bool, Error> {
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
    
    private func saveData() throws {
        try storage.save(id: Self.history, object: data)
    }
}
