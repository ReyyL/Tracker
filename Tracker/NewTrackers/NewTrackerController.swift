//
//  NewTrackerController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 16.06.2024.
//

import UIKit

final class NewTrackerController: UIViewController {
    
    weak var delegate: TrackerCreationDelegete?
    
    private let habitButton = {
        let habitButton = Button(title: "Привычка", backColor: .yBlack, textColor: .yWhite)
        habitButton.addTarget(self, action: #selector(addNewHabit), for: .touchUpInside)
        return habitButton
    }()
    
    private let eventButton = {
        let eventButton = Button(title: "Нерегулярное событие", backColor: .yBlack, textColor: .yWhite)
        eventButton.addTarget(self, action: #selector(addNewEvent), for: .touchUpInside)
        return eventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    private func setupScreen() {
        
        view.backgroundColor = .yWhite
        
        title = "Создание трекера"
        
        let buttonsView = UIStackView(arrangedSubviews: [habitButton, eventButton])
        buttonsView.axis = .vertical
        buttonsView.spacing = 16
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            
            buttonsView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func addNewHabit() {
        
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.delegate = delegate
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    @objc private func addNewEvent() {
        
        let newEventViewController = NewEventViewController()
        newEventViewController.delegate = delegate
        navigationController?.pushViewController(newEventViewController, animated: true)
    }
}
