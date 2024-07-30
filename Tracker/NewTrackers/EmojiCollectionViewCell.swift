//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Andrey Lazarev on 29.06.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let reuseEmojiIdentifier = "emojiCell"
    
    private lazy var emojiView = {
        let emojiView = UIView()
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.layer.cornerRadius = 16
        return emojiView
    }()
    
    lazy var emoji = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return emoji
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScreen() {
        addSubview(emojiView)
        emojiView.addSubview(emoji)
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emojiView.widthAnchor.constraint(equalToConstant: 52),
            emojiView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func didSelectEmoji() {
        emojiView.backgroundColor = .yLightGray
    }
}
