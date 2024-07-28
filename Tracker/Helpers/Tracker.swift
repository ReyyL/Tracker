//
//  Tracker.swift
//  Tracker
//
//  Created by Andrey Lazarev on 06.06.2024.
//

import UIKit

struct Tracker {
    
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let category: String
}
