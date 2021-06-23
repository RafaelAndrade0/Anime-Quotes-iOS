//
//  QuotesTableViewCell.swift
//  AnimeQuotes
//
//  Created by Rafaell Andrade on 21/06/21.
//

import UIKit


class QuotesTableViewCellModel {
    let quote: String
    let character: String
    
    init(quote: String, character: String) {
        self.quote = quote
        self.character = character
    }
}

class QuotesTableViewCell: UITableViewCell {
    static let identifier = "QuotesTableViewCell"
    
    private let quotesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 3
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(quotesLabel)
        contentView.addSubview(characterLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        quotesLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 20,
            height: 70
        )
        characterLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width/2,
            height: contentView.frame.size.height/3
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quotesLabel.text = nil
        characterLabel.text = nil
    }
    
    func configure(with viewModel: QuotesTableViewCellModel) {
        quotesLabel.text = viewModel.quote
        characterLabel.text = viewModel.character
    }
}
