//
//  DocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation

class DocumentsRepository: QueryRepository {
    private static let url = "https://api.plos.org/search?start=0&rows=10&fl=id,journal,publication_date,title_display,article_type,author_display,abstract,counter_total_all"

    private let network: Network
    private let mapper: AnyMapper<DocumentDTO, Document>

    init(network: Network, mapper: AnyMapper<DocumentDTO, Document>) {
        self.network = network
        self.mapper = mapper
    }

    func read(query: String) async throws -> [Document] {
        let data = try await network
            .get(with: Self.url + "&q=title:\(query)")
        let documentsDTO = try JSONDecoder()
            .decode(DocumentResultDTO.self, from: data)
        return documentsDTO.response
            .docs.map(mapper.map)
    }
}
