//
//  DocumentsMapper.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation

class DocumentsMapper: Mapper {
    func map(input: DocumentDTO) -> Document {
        return Document(id: input.id,
                        publicationDate: dateGet(from: input.publication_date),
                        authorDisplay: input.author_display
                            .joined(separator: ", "),
                        abstract: input.abstract
                            .joined(separator: " ")
                            .trimmingCharacters(in: CharacterSet(arrayLiteral: " ", "\n")),
                        titleDisplay: input.title_display,
                        articleType: input.article_type,
                        journal: input.journal,
                        counterTotallAll: input.counter_total_all)
    }
    
    private func dateGet(from dateString: String) -> String {
        var res = dateString
        if let date = ISO8601DateFormatter().date(from: dateString) {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            res = formatter.string(from: date)
        }
        return res
    }
}
