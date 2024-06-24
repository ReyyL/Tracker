//
//  Button.swift
//  Tracker
//
//  Created by Andrey Lazarev on 24.06.2024.
//

import UIKit

final class Button: UIButton {
    init(title: String, backColor: UIColor, textColor: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        self.backgroundColor = backColor
        self.layer.cornerRadius = 16
        self.setTitleColor(textColor, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
