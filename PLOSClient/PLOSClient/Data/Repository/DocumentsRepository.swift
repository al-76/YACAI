//
//  DocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import Foundation

struct DocumentsRepository: QueryRepository {
    private static let url = "https://api.plos.org/search?start=0&rows=10&fl=id,journal,publication_date,title_display,article_type,author_display,abstract,counter_total_all"

    private let network: Network
    private let mapper: AnyMapper<DocumentDTO, Document>

    init(network: Network, mapper: AnyMapper<DocumentDTO, Document>) {
        self.network = network
        self.mapper = mapper
    }

    func read(query: String) -> AnyPublisher<[Document], Error> {
        Future { promise in
            self.network
                .get(with: Self.url + "&q=title:\(query)") { result in
                    do {
                        let data = try result.get()
                        let documentsDTO = try JSONDecoder()
                            .decode(DocumentResultDTO.self, from: data)
                        let documents = documentsDTO.response
                            .docs.map(self.mapper.map)
                        promise(.success(documents))
                    } catch {
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
