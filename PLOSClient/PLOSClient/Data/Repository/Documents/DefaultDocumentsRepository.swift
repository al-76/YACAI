//
//  DefaultDocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import Foundation

final class DefaultDocumentsRepository: DocumentsRepository {
    enum DocumentsRepositoryError: Error {
        case invalidUrl
    }

    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func read(query: String) -> AnyPublisher<[Document], Error> {
        network
            .request(url: getApiUrl(query))
            .decode(type: DocumentResultDTO.self,
                    decoder: DocumentResultDTO.jsonDecoder)
            .map(\.response.docs)
            .eraseToAnyPublisher()
    }

    private func getApiUrl(_ query: String) -> URL {
        var components = URLComponents(string: "https://api.plos.org/search")!
        components.queryItems = [
            URLQueryItem(name: "start", value: "0"),
            URLQueryItem(name: "rows", value: "10"),
            URLQueryItem(name: "fl", value: "id,journal,publication_date,title_display,article_type,author_display,abstract,counter_total_all"),
            URLQueryItem(name: "q", value: "title:\(query)")
        ]
        return components.url!
    }
}
