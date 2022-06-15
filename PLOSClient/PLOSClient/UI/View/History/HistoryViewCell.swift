//
//  HistoryViewCell.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 10.08.2021.
//

import UIKit

final class HistoryViewCell: UITableViewCell {
    @IBOutlet weak var history: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setHistory(with history: History) {
        self.history.text = history.id
    }
}
