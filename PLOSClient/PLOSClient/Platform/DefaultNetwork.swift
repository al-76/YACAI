//
//  DefaultNetwork.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Foundation

final class DefaultNetwork: Network {
    enum DefaultNetworkError: Error {
        case invalidUrl(url: String)
        case unknownError
    }
    
    func get(with url: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let task = URLSession.shared
                    .dataTask(with: try createUrl(from: url)) { data, _, error in
                        if let data = data {
                            continuation.resume(returning: data)
                        } else if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(throwing: Self.DefaultNetworkError.unknownError)
                        }
                    }
                task.resume()
            } catch let error {
                continuation.resume(throwing: error)
            }
        }
    }

    private func createUrl(from stringUrl: String) throws -> URL {
        guard let url = URL(string: stringUrl) else { throw Self.DefaultNetworkError.invalidUrl(url: stringUrl) }
        return url
    }
}

extension DefaultNetwork.DefaultNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidUrl(url):
            return NSLocalizedString("Invalid url: " + url, comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
