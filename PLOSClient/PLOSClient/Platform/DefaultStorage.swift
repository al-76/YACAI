//
//  DefaultStorage.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Foundation

class DefaultStorage: Storage {
    func get<T: Codable>(id: String, defaultObject: T) -> T {
        guard let url = getUrl(from: id),
              FileManager.default.fileExists(atPath: url.path),
              let data = FileManager.default.contents(atPath: url.path) else { return defaultObject }

        let decoder = JSONDecoder()
        return (try? decoder.decode(T.self, from: data)) ?? defaultObject
    }

    func save<T: Codable>(id: String, object: T) throws {
        guard let url = getUrl(from: id) else { return }
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }

    func clear(id: String) throws {
        if let url = getUrl(from: id) {
            try FileManager.default.removeItem(at: url)
        }
    }

    private func getUrl(from: String) -> URL? {
        try? FileManager.default.url(for: .cachesDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: true)
            .appendingPathComponent(from, isDirectory: false)
    }
}
