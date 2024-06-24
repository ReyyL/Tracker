//
//  TrackerTextField.swift
//  Tracker
//
//  Created by Andrey Lazarev on 24.06.2024.
//

import UIKit

final class TrackerTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .yLightGray
        self.layer.cornerRadius = 16
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
