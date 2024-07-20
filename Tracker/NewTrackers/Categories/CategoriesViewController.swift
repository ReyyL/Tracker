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
    
    var viewModel: CategoriesViewModel?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var tableView = {
        let tableView = TrackerTable()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var createButton = {
        let saveButton = Button(title: "Добавить новую категорию", backColor: .yBlack, textColor: .yWhite)
        saveButton.addTarget(self, action: #selector(createNewCategory), for: .touchUpInside)
        return saveButton
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "starWhenEmpty")
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно \nобъединить по смыслу"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var placeholderStackView = {
        let stackView = UIStackView(arrangedSubviews: [image,label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupScreen()
        viewModel?.loadCategories()
        showPlaceholder()
    }
    
    @objc
    private func createNewCategory() {
        let categoryCreationViewController = CategoryCreationViewController()
        categoryCreationViewController.delegate = self
        let navigationVC = UINavigationController(rootViewController: categoryCreationViewController)
        present(navigationVC, animated: true)
    }
    
    private func showPlaceholder() {
        
        if let categories = viewModel?.categories.count {
            if categories == 0 {
                placeholderStackView.isHidden = false
            }
        }
    }
    
    private func setupScreen() {
        
        
        title = "Категория"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        view.backgroundColor = .yWhite
        
        view.addSubview(createButton)
        
        view.addSubview(placeholderStackView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: createButton.topAnchor),
            
            placeholderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
            
            createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        viewModel?.sendCategoryAfterTap(indexPath: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel?.categories[indexPath.row] ?? ""
        cell.selectionStyle = .none
        cell.backgroundColor = .yLightGrayAlpha
        
        return cell
    }
}

extension CategoriesViewController: CategoryCreationDelegate {
    func refreshTable(text: String) {
        guard let categories = viewModel?.categories else { return }
        
        if !categories.contains(text) {
            viewModel?.categories.append(text)
        }
        tableView.reloadData()
        trackerCategoryStore.saveToCoreData(TrackerCategory(title: text, trackersArray: []))
        placeholderStackView.isHidden = true
    }
}
