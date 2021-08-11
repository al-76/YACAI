//
//  DocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation
import RxSwift

class DocumentsRepository: QueryRepository {
    private static let url = "https://api.plos.org/search?start=0&rows=10&fl=id,journal,publication_date,title_display,article_type,author_display,abstract,counter_total_all"

    private let network: Network
    private let mapper: AnyMapper<DocumentDTO, Document>

    init(network: Network, mapper: AnyMapper<DocumentDTO, Document>) {
        self.network = network
        self.mapper = mapper
    }

    func read(query: String) -> Observable<DocumentResult> {
        return Observable.create { [weak self] observer in
            var cancellable: Cancellable?
            if let self = self {
                cancellable = self.network
                    .get(with: Self.url + "&q=title:\(query)") { result in
                        do {
                            let data = try result.get() as Data
                            let documentsDTO = try JSONDecoder()
                                .decode(DocumentResultDTO.self, from: data)
                            let documents = documentsDTO.response
                                .docs.map(self.mapper.map)
                            observer.onNext(.success(documents))
                        } catch {
                            observer.onNext(.failure(error))
                        }
                        observer.onCompleted()
                    }
            } else {
                observer.onCompleted()
            }
            return Disposables.create { cancellable?.cancel() }
        }
    }
}
