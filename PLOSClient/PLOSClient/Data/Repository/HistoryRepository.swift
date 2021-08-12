//
//  HistoryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Foundation
import RxSwift

class HistoryRepository: CommandRepository, QueryRepository {
    private static let history = "history"
    
    private let storage: Storage
    private lazy var data: [History] = {
        self.storage.get(id: Self.history, defaultObject: [History]())
    }()
    
    init(storage: Storage) {
        self.storage = storage
    }

    func add(item: History) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            if let self = self {
                if !self.data.contains(item) {
                    self.data.append(item)
                    do {
                        try self.saveData()
                        observer.onNext(true)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func read(query: String) -> Observable<[History]> {
        return Observable.create { [weak self] observer in
            if let res = self?.data
                .filter({ query.isEmpty || $0.id.contains(query) }) {
                observer.onNext(res)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func saveData() throws {
        try storage.save(id: Self.history, object: data)
    }
}
