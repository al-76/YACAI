//
//  Document.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Foundation

struct Document: Codable, Identifiable, Equatable {
    let id: String
    let publicationDate: String
    let authorDisplay: String
    let abstract: String
    let titleDisplay: String
    let articleType: String
    let journal: String
    let counterTotallAll: Int
}
