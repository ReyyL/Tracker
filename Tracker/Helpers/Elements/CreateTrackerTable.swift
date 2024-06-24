//
//  CreateTrackerTable.swift
//  Tracker
//
//  Created by Andrey Lazarev on 24.06.2024.
//

import UIKit

final class TrackerTable: UITableView {
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        self.layer.cornerRadius = 16
        self.backgroundColor = .yLightGray
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
