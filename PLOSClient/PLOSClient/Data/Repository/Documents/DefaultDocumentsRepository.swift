//
//  DefaultDocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import Foundation

final class DefaultDocumentsRepository: DocumentsRepository {
    private let network: Network
    private let mapper: AnyMapper<DocumentDTO, Document>

    init(network: Network, mapper: AnyMapper<DocumentDTO, Document>) {
        self.network = network
        self.mapper = mapper
    }

    func read(query: String) -> AnyPublisher<[Document], Error> {
        network
            .request(url: getApiUrl(query))
            .decode(type: DocumentResultDTO.self, decoder: JSONDecoder())
            .map { [weak self] in
                guard let self else { return [] }
                return $0.response.docs.compactMap(self.mapper.map)
            }
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
