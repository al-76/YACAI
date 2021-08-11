//
//  DefaultNetwork.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Foundation

class DefaultNetwork: Network {
    enum DefaultNetworkError: Error {
        case invalidUrl(url: String)
        case unknownError
    }
    
    private class CancellableTask: Cancellable {
        private let task: URLSessionTask
        
        init(_ task: URLSessionTask) {
            self.task = task
        }
        
        func cancel() {
            task.cancel()
        }
    }

    func get(with url: String, completion: @escaping Completion) -> Cancellable? {
        var result: Cancellable?
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
            result = CancellableTask(task)
        } catch {
            completion(.failure(error))
        }
        return result
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
