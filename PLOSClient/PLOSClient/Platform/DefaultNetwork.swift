//
//  DefaultNetwork.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Combine
import Foundation

final class DefaultNetwork: Network {
    func request(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .eraseToAnyPublisher()
    }
}
