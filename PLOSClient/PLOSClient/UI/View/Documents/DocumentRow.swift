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
            Text("\(document.journal), \(document.publicationDate)")
                .padding(2)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Views: \(document.counterTotallAll)")
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
        DocumentRow(document: Document(id: "test",
                                           publicationDate: "25 April 1953",
                                           authorDisplay: "J. D. Watson, F. H. C. Crick",
                                           abstract: "We wish to suggest a structure for the salt of deoxyribose nucleic acid (D.N.A.). This structure has novel features which are of considerable biological interest. A structure for nucleic acid has already been proposed by Pauling and Corey'. They kindly made their manuscript available to us in advance of publication. Their model consists of three intertwined chains, with the phosphates near the fibre axis, and the bases on the outside. In our opinion, this structure is unsatisfactory for two reasons: (I) We believe that the material which gives the X-ray diagrams is the salt, not the free acid. Without the acidic hydrogen atoms it is not clear what forces would hold the structure together, especially as thenegatively charged phosphates near the axis will repel each other.",
                                           titleDisplay: "Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid",
                                           articleType: "Research",
                                           journal: "Nature",
                                           counterTotallAll: 40000))
    }
}
