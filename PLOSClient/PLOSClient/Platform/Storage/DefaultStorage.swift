//
//  DefaultStorage.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Combine
import Foundation

final class DefaultStorage<T: Codable>: Storage {
    private let name: String

    init(name: String) {
        self.name = name
    }

    func save(item: T) -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            do {
                var items = try self?.loadData() ?? []
                items.append(item)
                try self?.saveData(items)
                promise(.success(true))
            } catch let error {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func load() -> AnyPublisher<[T], Error> {
        Future { [weak self] promise in
            do {
                promise(.success(try self?.loadData() ?? []))
            } catch let error {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    private func getUrl(from name: String) -> URL? {
        try? FileManager.default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(name, isDirectory: false)
    }

    private func loadData() throws -> [T] {
        guard let url = getUrl(from: name),
              let data = FileManager.default.contents(atPath: url.path) else {
            return []
        }

        return try JSONDecoder().decode([T].self, from: data)
    }

    private func saveData(_ items: [T]) throws {
        guard let url = getUrl(from: name) else {
            return
        }

        FileManager.default
            .createFile(atPath: url.path,
                        contents: try JSONEncoder().encode(items),
                        attributes: nil)
    }
}
