//
//  Document.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Foundation

struct Document: Codable, Identifiable, Equatable {
    let id: String
    let publicationDate: Date
    let authorDisplay: String
    let abstract: String
    let titleDisplay: String
    let articleType: String
    let journal: String
    let counterTotalAll: Int
}

#if DEBUG

// MARK: - Document stub
extension Document {
    static let stub = [Document].stub[0]
}

extension Array where Element == Document {
    static let stub = [
        Document(
            id: "test",
            publicationDate: Date.distantPast,
            authorDisplay: "J. D. Watson, F. H. C. Crick",
            abstract: "We wish to suggest a structure for the salt of deoxyribose nucleic acid (D.N.A.). This structure has novel features which are of considerable biological interest. A structure for nucleic acid has already been proposed by Pauling and Corey'. They kindly made their manuscript available to us in advance of publication. Their model consists of three intertwined chains, with the phosphates near the fibre axis, and the bases on the outside. In our opinion, this structure is unsatisfactory for two reasons: (I) We believe that the material which gives the X-ray diagrams is the salt, not the free acid. Without the acidic hydrogen atoms it is not clear what forces would hold the structure together, especially as thenegatively charged phosphates near the axis will repel each other.",
            titleDisplay: "Molecular Structure of Nucleic Acids: A Structure for Deoxyribose Nucleic Acid",
            articleType: "Research",
            journal: "Nature",
            counterTotalAll: 40000
        )
    ]
}

#endif
