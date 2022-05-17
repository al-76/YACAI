//
//  DocumentsViewModel.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

class DocumentsViewModel {
    var documents = Binder<[Document]>(value: [])
    var error = BinderOpt<Error>(value: nil)
    
    private let searchUseCase: AnyUseCase<String, [Document]>
    
    init(searchUseCase: AnyUseCase<String, [Document]>) {
        self.searchUseCase = searchUseCase
    }
    
    func search(document name: String) {
        Task {
            do {
                documents.value = try await searchUseCase.execute(with: name)
            } catch let error {
                self.error.value = error
            }
        }
    }
}
