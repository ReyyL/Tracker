//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 16.06.2024.
//

import UIKit

enum Weekday: String, CaseIterable {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Cб"
    case sunday = "Вс"
}

protocol NewHabitDelegate: AnyObject {
    func sendSelectedDays(selectedDays: [Weekday])
    var daysFromSchedule: [Weekday] { get }
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: NewHabitDelegate?
    
    let weekDays: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    let weekdaysString = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    private var isSelected = false
    
    private var selectedDays = [Weekday]()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 16
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var readyButton = {
        
        let readyButton = Button(title: "Готово", backColor: .yBlack, textColor: .yWhite)
        return readyButton
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupScreen()
    }
    
    private func setupScreen() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .yWhite
        
        title = "Расписание"
        
        view.addSubview(tableView)
        
        readyButton.addTarget(self, action: #selector(saveSchedule), for: .touchUpInside)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func saveSchedule(sender: UIButton) {
        
        delegate?.sendSelectedDays(selectedDays: selectedDays)
        self.dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekdaysString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScheduleTableViewCell, let days = delegate?.daysFromSchedule else { return UITableViewCell() }
        selectedDays = days
        
        isSelected = selectedDays.contains(weekDays[indexPath.row])
        
        cell.configureCell(weekdaysString[indexPath.row], weekday: weekDays[indexPath.row], isSelected: isSelected)
        cell.delegate = self
        
        return cell
    }
}

extension ScheduleViewController: WeekdayDelegate {
    func weekdayAppend(_ weekDay: Weekday) {
        selectedDays.append(weekDay)
    }
    
    func weekdayRemove(_ weekDay: Weekday) {
        guard let index = selectedDays.firstIndex(of: weekDay) else { return }
        selectedDays.remove(at: index)
    }
}
