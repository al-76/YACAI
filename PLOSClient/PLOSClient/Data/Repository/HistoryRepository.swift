//
//  HistoryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Foundation

final class HistoryRepository: CommandRepository, QueryRepository {
    private static let history = "history"
    
    private let storage: Storage
    private lazy var data: [History] = {
        self.storage.get(id: Self.history, defaultObject: [History]())
    }()
    
    init(storage: Storage) {
        self.storage = storage
    }

    func add(item: History) async throws -> Bool {
        guard !data.contains(item) else { return false }
        
        data.append(item)
        try saveData()
        
        return true
    }

    func read(query: String) async throws -> [History] {
        data.filter { query.isEmpty || $0.id.contains(query) }
    }
    
    private func saveData() throws {
        try storage.save(id: Self.history, object: data)
    }
}
