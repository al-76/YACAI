//
//  DocumentsViewCell.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 10.08.2021.
//

import UIKit
import RxSwift
import SafariServices

final class DocumentsViewCell: UITableViewCell {
    enum Error: Swift.Error {
        case invalidUrl(url: String)
    }
    
    typealias PresentViewController = (UIViewController?, Error?) -> ()
    
    private let url = "https://doi.org/"
    
    @IBOutlet weak var articleType: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var abstract: UITextView!
    @IBOutlet weak var journalAndPublication: UILabel!
    @IBOutlet weak var counter: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func setDocument(with document: Document, presentViewController:  @escaping PresentViewController) {
        articleType.text = document.articleType
        title.text = document.titleDisplay
        title.underline()
        author.text = document.authorDisplay
        abstract.text = document.abstract
        journalAndPublication
            .setValue(document.journal)
            .setValue(document.publicationDate)
        counter.setValue(String(document.counterTotallAll))
        
        let tapGesture = UITapGestureRecognizer()
        title.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
            guard let self = self else { return }
            if let url = URL(string: self.url + document.id) {
                presentViewController(SFSafariViewController(url: url), nil)
            } else {
                presentViewController(nil, Error.invalidUrl(url: self.url))
            }
        }).disposed(by: disposeBag)
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
