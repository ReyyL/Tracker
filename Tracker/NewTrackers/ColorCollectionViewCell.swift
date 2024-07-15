//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Andrey Lazarev on 29.06.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    private lazy var colorView = {
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()
    
    lazy var color = {
        let color = UIView()
        color.translatesAutoresizingMaskIntoConstraints = false
        color.layer.cornerRadius = 8
        return color
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScreen() {
        addSubview(colorView)
        colorView.addSubview(color)
        
        NSLayoutConstraint.activate([
            color.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            color.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            color.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            color.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
            colorView.widthAnchor.constraint(equalToConstant: 52),
            colorView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
