//
//  Document+Extension.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

@testable import PLOSClient

extension Document: Equatable {
    public static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Document {
    init(_ id: String) {
        self.init(id: id,
                  publicationDate: "test",
                  authorDisplay: "test",
                  abstract: "test",
                  titleDisplay: "test",
                  articleType: "test",
                  journal: "test",
                  counterTotallAll: 1000)
    }
}
