//
//  Document.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Foundation

// https://api.plos.org/search?q=title:DNA&start=0&rows=10&fl=id,journal,publication_date,title_display,article_type,author_display,abstract,counter_total_all
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
