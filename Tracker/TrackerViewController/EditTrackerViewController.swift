//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 27.07.2024.
//

import UIKit

final class EditTrackerViewController: NewHabitViewController {
    
    private lazy var daysCount = {
        let days = UILabel()
        days.font = .systemFont(ofSize: 32, weight: .bold)
        days.textAlignment = .center
        days.translatesAutoresizingMaskIntoConstraints = false
        return days
    }()
    
    private var id: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override func setupScreen() {
        
        saveButton.isEnabled = true
        saveButton.backgroundColor = .yBlack
        
        super.setupScreen()
        
        title = "Редактирование привычки"
        contentView.addSubview(daysCount)
        
        NSLayoutConstraint.activate([
            daysCount.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            daysCount.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            daysCount.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            daysCount.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    override func saveTrackerScreen() {
        guard let trackerName = categoryTextField.text, let id else { return }
        let newTracker = Tracker(id: id, name: trackerName, color: selectedColor, emoji: selectedEmoji, schedule: selectedDays, category: selectedCategory)
        
        delegate?.createTracker(tracker: newTracker)
        self.dismiss(animated: true)
    }
    
    override func checkIfSaveButtonIsEnabled() {}
    
    func getDataForEdit(tracker: Tracker, completedDays: Int) {
        isEdit = true
        id = tracker.id
        categoryTextField.text = tracker.name
        selectedDays = tracker.schedule
        selectedEmoji = tracker.emoji
        selectedCategory = tracker.category
        selectedColor = tracker.color
        daysCount.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of remaining days"),
            completedDays
        )
        collectionView.reloadData()
    }
}
