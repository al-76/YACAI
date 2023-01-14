//
//  ViewError+Equatable.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import Foundation

@testable import PLOSClient

extension ViewError: Equatable {
    public static func == (lhs: ViewError, rhs: ViewError) -> Bool {
        lhs.id == rhs.id
    }
}
