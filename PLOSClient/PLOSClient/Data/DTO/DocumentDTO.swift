//
//  DocumentDTO.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation

struct DocumentResultDTO: Decodable {
    let response: DocumentResponseDTO
}

struct DocumentResponseDTO: Decodable {
    let numFound: Int
    let start: Int
    let docs: [Document]
}

extension DocumentResultDTO {
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

extension Document {
    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate
        case authorDisplay
        case abstract
        case titleDisplay
        case articleType
        case journal
        case counterTotalAll
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        journal = try container.decode(String.self, forKey: .journal)
        publicationDate = try container.decode(Date.self, forKey: .publicationDate)
        authorDisplay = try container.decode([String].self, forKey: .authorDisplay)
            .joined(separator: ", ")
        abstract = try container.decode([String].self, forKey: .abstract)
            .joined(separator: " ")
        articleType = try container.decode(String.self, forKey: .articleType)
        titleDisplay = try container.decode(String.self, forKey: .titleDisplay)
        counterTotalAll = try container.decode(Int.self, forKey: .counterTotalAll)
    }
}
