//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Andrey Lazarev on 18.06.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 17)
        title.textColor = .yBlack
        return title
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        
        contentView.backgroundColor = .yLightGrayAlpha
        contentView.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
