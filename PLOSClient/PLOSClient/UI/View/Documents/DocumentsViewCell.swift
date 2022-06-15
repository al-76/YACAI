//
//  DocumentsViewCell.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 10.08.2021.
//

import UIKit
import SafariServices

final class DocumentsViewCell: UITableViewCell {
    enum Error: Swift.Error {
        case invalidUrl(url: String)
    }
    
    typealias PresentViewController = (UIViewController?, Error?) -> ()
    
    private let url = "https://doi.org/"
    
    private var documentId = ""
    private var presentViewController: PresentViewController? = nil
    
    @IBOutlet weak var articleType: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var abstract: UITextView!
    @IBOutlet weak var journalAndPublication: UILabel!
    @IBOutlet weak var counter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDocument(with document: Document, presentViewController:  @escaping PresentViewController) {
        documentId = document.id
        self.presentViewController = presentViewController
        
        articleType.text = document.articleType
        title.text = document.titleDisplay
        title.underline()
        author.text = document.authorDisplay
        abstract.text = document.abstract
        journalAndPublication
            .setValue(document.journal)
            .setValue(document.publicationDate)
        counter.setValue(String(document.counterTotallAll))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDocument(recognizer:)))
        title.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapDocument(recognizer: UITapGestureRecognizer) {
        if let url = URL(string: self.url + self.documentId) {
            presentViewController?(SFSafariViewController(url: url), nil)
        } else {
            presentViewController?(nil, Error.invalidUrl(url: self.url))
        }
    }
}

extension DocumentsViewCell.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidUrl(url):
            return NSLocalizedString("Invalid url: " + url, comment: "")
        }
    }
}

private extension UILabel {
    @discardableResult func setValue(_ value: String) -> UILabel {
        if let text = self.text,
           let range = text.range(of: "%s") {
            self.text = text.replacingCharacters(in: range, with: value)
        }
        return self
    }
}

private extension UILabel {
    func underline() {
        if let text = self.text {
          let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
