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

    func get(with url: String, completion: @escaping Completion) {
        do {
            let task = URLSession.shared
                .dataTask(with: try createUrl(from: url)) { data, _, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(Self.DefaultNetworkError.unknownError))
                    }
                }
            task.resume()
        } catch {
            completion(.failure(error))
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
