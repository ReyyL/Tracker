//
//  CategoryCreationViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 15.07.2024.
//

import UIKit

protocol CategoryCreationDelegate: AnyObject {
    func refreshTable(text: String)
}

final class CategoryCreationViewController: UIViewController {
    
    weak var delegate: CategoryCreationDelegate?
    
    private lazy var textField: UITextField = {
        let textField = TrackerTextField(placeholder: "Введите название категории")
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var okButton: UIButton = {
        let button = Button(title: "Готово", backColor: .yBlack, textColor: .yWhite)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .yGray
            
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    private func setupScreen() {
        view.backgroundColor = .yWhite
        
        title = "Новая категория"
        
        view.addSubview(textField)
        view.addSubview(okButton)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            okButton.heightAnchor.constraint(equalToConstant: 60),
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    @objc private func textFieldDidChange() {
        if textField.hasText {
            okButton.isEnabled = true
            okButton.backgroundColor = .yBlack
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .yGray
        }
    }
    
    @objc private func save() {
        dismiss(animated: true)
        delegate?.refreshTable(text: textField.text ?? "")
    }
}
