//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 21.06.2024.
//

import UIKit

protocol CategoryDelegate: AnyObject {
    
    func sendSelectedCategory(selectedCategory: String)
}

final class CategoriesViewController: UIViewController {
    
    weak var delegate: CategoryDelegate?
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .yLightGrayAlpha
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var saveButton = {
        let saveButton = Button(title: "Добавить новую категорию", backColor: .yBlack, textColor: .yWhite)
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(createNewCategory), for: .touchUpInside)
        return saveButton
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupScreen()
    }
    
    @objc
    private func createNewCategory() {
        
    }
    
    private func setupScreen() {
        title = "Категория"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        view.backgroundColor = .yWhite
        
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
}

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Категория"
        cell.selectionStyle = .none
        cell.backgroundColor = .yLightGrayAlpha
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        delegate?.sendSelectedCategory(selectedCategory: "Категория")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
}
