//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Andrey Lazarev on 16.06.2024.
//

import UIKit

protocol WeekdayDelegate: AnyObject {
    func weekdayAppend(_ weekDay: Weekday)
    func weekdayRemove(_ weekDay: Weekday)
}

final class ScheduleTableViewCell: UITableViewCell {
    
    weak var delegate: WeekdayDelegate?
    
    var selectedDays: Weekday?
    
    var isSwitchOn: Bool = false {
            didSet {
                daySwitch.isOn = isSwitchOn
            }
        }
    
    private lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.font = .systemFont(ofSize: 17)
        return titleView
    }()
    
    private lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = .yBlue
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return daySwitch
        
    }()
    
    var weekday: Weekday?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSchedule()
        daySwitch.addTarget(self, action: #selector(addDay), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ weekDay: String, weekday: Weekday, isSelected: Bool) {
            titleView.text = weekDay
            self.weekday = weekday
            isSwitchOn = isSelected
    }
    
    @objc private func addDay(_ sender: UISwitch) {
        guard let weekday else { return }
        isSwitchOn = sender.isOn
        sender.isOn ? delegate?.weekdayAppend(weekday) : delegate?.weekdayRemove(weekday)
        
    }
    
    private func setupSchedule() {
        contentView.backgroundColor = .yLightGrayAlpha
        
        contentView.addSubview(titleView)
        contentView.addSubview(daySwitch)
        
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}



