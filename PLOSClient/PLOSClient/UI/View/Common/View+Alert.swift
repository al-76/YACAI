//
//  View+Alert.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import Foundation
import SwiftUI

struct ViewError: Identifiable {
    private let error: Error
    
    var id: String { self.localizedDescription }
    var localizedDescription: String { self.error.localizedDescription }
    
    init(_ error: Error) {
        self.error = error
    }
}

extension View {
    func alertError(error: Binding<ViewError?>) -> some View {
        alert(item: error, content: { error in
            Alert(title: Text("Error"),
                  message: Text(error.localizedDescription),
                  dismissButton: .default(Text("OK")))
        })
    }
}
