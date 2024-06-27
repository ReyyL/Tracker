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

final class NewHabitViewController: UIViewController {
    
    weak var delegate: TrackerCreationDelegete?
    
    private let tableView = {
        let tableView = TrackerTable()
        return tableView
    }()
    
    private lazy var categoryTextField = {
        let categoryTextField = TrackerTextField(placeholder: "Введите название трекера")
        categoryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return categoryTextField
    }()
    
    private lazy var cancelButton = {
        let cancelButton = Button(title: "Отменить", backColor: .yWhite, textColor: .yRed)
        cancelButton.layer.borderColor = UIColor.yRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(cancelTrackerScreen), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var saveButton = {
        let saveButton = Button(title: "Создать", backColor: .yGray, textColor: .yWhite)
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveTrackerScreen), for: .touchUpInside)
        return saveButton
    }()
    
    private lazy var tableCellTitles = ["Категория", "Расписание"]
    
    private var selectedDays = [Weekday]()
    
    private var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    private func setupScreen() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        view.backgroundColor = .yWhite
        
        self.title = "Новая привычка"
        view.backgroundColor = .yWhite
        navigationItem.hidesBackButton = true
        
        view.addSubview(categoryTextField)
        
        let bottomButtonsView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        bottomButtonsView.axis = .horizontal
        bottomButtonsView.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsView.spacing = 8
        bottomButtonsView.distribution = .fillEqually
        
        view.addSubview(bottomButtonsView)
        
        NSLayoutConstraint.activate([
            categoryTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            bottomButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            bottomButtonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            bottomButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func textFieldDidChange() {
        
        checkIfSaveButtonIsEnabled()
    }
    
    @objc private func cancelTrackerScreen() {
        
        self.dismiss(animated: true)
    }
    
    @objc private func saveTrackerScreen() {
        
        guard let trackerName = categoryTextField.text else { return }
        let newTracker = Tracker(id: UUID(), name: trackerName, color: .yRed, emoji: "🍺", schedule: selectedDays)
        
        delegate?.createTracker(tracker: newTracker)
        self.dismiss(animated: true)
    }
    
    private func createSchedule() {
        let newScheduleViewController = ScheduleViewController()
        let navigationNewScheduleViewController = UINavigationController(rootViewController: newScheduleViewController)
        newScheduleViewController.delegate = self
        present(navigationNewScheduleViewController, animated: true)
    }
    
    private func chooseCategory() {
        let categoryViewController = CategoriesViewController()
        let navigationCategoryViewController = UINavigationController(rootViewController: categoryViewController)
        categoryViewController.delegate = self
        present(navigationCategoryViewController, animated: true)
    }
    
    private func checkIfSaveButtonIsEnabled() {
        
        if !selectedDays.isEmpty && !selectedCategory.isEmpty && categoryTextField.hasText {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .yBlack
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .yGray
        }
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

extension NewHabitViewController: CategoryDelegate {
    func sendSelectedCategory(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        checkIfSaveButtonIsEnabled()
        tableView.reloadData()
    }
}


