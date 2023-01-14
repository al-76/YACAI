//
//  History.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Foundation

struct History: Codable, Identifiable, Equatable {
    let id: String
}

// MARK: - History stub
extension History {
    static let stub = History(id: "Ribosome")
}

extension Array where Element == History {
    static let stub = [
        History(id: "Ribosome"),
        History(id: "RER"),
        History(id: "SER"),
        History(id: "Lysosome"),
        History(id: "Endosome")
    ]
}
