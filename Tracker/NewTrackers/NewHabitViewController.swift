//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 16.06.2024.
//

import UIKit

protocol TrackerCreationDelegete: AnyObject {
    func createTracker(tracker: Tracker)
}

class NewHabitViewController: TrackerCreationViewController {
    
    private lazy var tableCellTitles = ["Категория", "Расписание"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override func setupScreen() {
        
        super.setupScreen()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Новая привычка"
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    override func checkIfSaveButtonIsEnabled() {
        if !selectedDays.isEmpty {
            super.checkIfSaveButtonIsEnabled()
        }
    }
    
    private func createSchedule() {
        let newScheduleViewController = ScheduleViewController()
        let navigationNewScheduleViewController = UINavigationController(rootViewController: newScheduleViewController)
        newScheduleViewController.delegate = self
        present(navigationNewScheduleViewController, animated: true)
    }
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = tableCellTitles[indexPath.row]
        
        switch name {
        case "Категория" :
            chooseCategory()
        case "Расписание":
            createSchedule()
        default:
            return
        }
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableCellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .yLightGrayAlpha
        cell.layer.cornerRadius = 16
        
        let name = "\(tableCellTitles[indexPath.row])"
        cell.textLabel?.text = name
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .yGray
        
        if name == "Категория" {
            cell.detailTextLabel?.text = selectedCategory
        }
        
        if name == "Расписание" {
            
            var strDays = [String]()
            for day in selectedDays {
                strDays.append(day.rawValue)
            }
            
            cell.detailTextLabel?.text = strDays.count == 7 
            ? "Каждый день"
            : strDays.joined(separator: ", ")
        }
        
        cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .yGray
        return cell
    }
}

extension NewHabitViewController: NewHabitDelegate {
    func sendSelectedDays(selectedDays: [Weekday]) {
        self.selectedDays = selectedDays
        checkIfSaveButtonIsEnabled()
        tableView.reloadData()
    }
}


