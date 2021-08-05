//
//  DocumentDTO.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

struct DocumentResultDTO: Decodable {
    let response: DocumentResponseDTO
}

struct DocumentResponseDTO: Decodable {
    let numFound: Int
    let start: Int
    let docs: [DocumentDTO]
}

struct DocumentDTO: Decodable {
    let id: String
    let journal: String
    let publication_date: String
    let title_display: String
    let article_type: String
    let author_display: [String]
    let abstract: [String]
    let counter_total_all: Int
}
