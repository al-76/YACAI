//
//  Document.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import Foundation

struct Document: Codable, Identifiable {
    let id: String
    let publicationDate: String
    let authorDisplay: String
    let abstract: String
    let titleDisplay: String
    let articleType: String
    let journal: String
    let counterTotallAll: Int
}

typealias DocumentResult = Result<[Document], Error>
