//
//  ViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input) -> Output
}
