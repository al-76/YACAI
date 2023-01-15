//
//  DocumentRow.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 29.07.2021.
//

import SwiftUI

struct DocumentRow: View {
    @State private var openDocument = false
    
    let document: Document
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(document.articleType)")
                .padding(2)
                .font(.caption)
            Text(document.titleDisplay)
                .underline()
                .padding(2)
                .font(.headline)
                .foregroundColor(.blue)
                .onTapGesture {
                    openDocument = true
                }
            Text(document.authorDisplay)
                .font(.subheadline)
                .bold()
                .lineLimit(2)
            Text(document.abstract)
                .font(.body)
                .padding(2)
                .lineLimit(10)
            Text("\(document.journal), \(document.publicationDate.formatted())")
                .padding(2)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Views: \(document.counterTotalAll)")
                .font(.footnote)
                .fontWeight(.bold)
                .padding(2)
        }.sheet(isPresented: $openDocument){
            SafariView(url: URL(string: "https://doi.org/\(document.id)")!)
        }
    }
}

struct DocumentRow_Previews: PreviewProvider {
    static var previews: some View {
        DocumentRow(document: .stub)
    }
}
