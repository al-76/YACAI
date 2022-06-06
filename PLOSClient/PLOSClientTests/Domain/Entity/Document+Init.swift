//
//  Document+Init.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 06.06.2022.
//

@testable import PLOSClient

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
