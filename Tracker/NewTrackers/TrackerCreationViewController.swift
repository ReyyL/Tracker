//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 30.06.2024.
//

import UIKit

class TrackerCreationViewController: UIViewController {
   
    
    weak var delegate: TrackerCreationDelegete?
    
    lazy var tableView = {
        let tableView = TrackerTable()
        return tableView
    }()
    
    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        collectionView.register(TrackerViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    lazy var saveButton = {
        let saveButton = Button(title: "Создать", backColor: .yGray, textColor: .yWhite)
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveTrackerScreen), for: .touchUpInside)
        return saveButton
    }()
    
    private var selectedEmoji = ""
    
    private var selectedColor = UIColor.clear
    
    var selectedCategory = ""
    
    var selectedDays = [Weekday]()
    
    private var prevSelectedEmojiIndex: IndexPath?
    private var prevSelectedColorIndex: IndexPath?
    
    private let headersForTrackerCreation = ["Emoji", "Цвет"]
    
    private let emojies = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱",
                            "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                            "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private let trackerColors: [UIColor] = [.yColor1, .yColor2, .yColor3, .yColor4, .yColor5, .yColor6, .yColor7, .yColor8, .yColor9, .yColor10, .yColor11, .yColor12,.yColor13,.yColor14,.yColor15,.yColor16,.yColor17, .yColor18]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    func setupScreen() {
        
        view.backgroundColor = .yWhite
        navigationItem.hidesBackButton = true
        
        view.addSubview(tableView)
        
        view.addSubview(categoryTextField)
        
        view.addSubview(collectionView)
        
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
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomButtonsView.bottomAnchor, constant: -24),
            
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
    
    @objc func saveTrackerScreen() {
        
        guard let trackerName = categoryTextField.text else { return }
        let newTracker = Tracker(id: UUID(), name: trackerName, color: selectedColor, emoji: selectedEmoji, schedule: selectedDays)
        
        delegate?.createTracker(tracker: newTracker, category: selectedCategory)
        self.dismiss(animated: true)
    }
    
    func chooseCategory() {
        let categoryViewModel = CategoriesViewModel()
        let categoryViewController = CategoriesViewController()
        categoryViewController.viewModel = categoryViewModel
        categoryViewModel.delegate = self
        let navigationVC = UINavigationController(rootViewController: categoryViewController)
        present(navigationVC, animated: true)
    }
    
    func checkIfSaveButtonIsEnabled() {
        
        if !selectedCategory.isEmpty &&
            categoryTextField.hasText &&
            selectedColor != UIColor.clear &&
            !selectedEmoji.isEmpty 
        {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .yBlack
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .yGray
        }
        
        
    }
}

extension TrackerCreationViewController: UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let count = section == 0 ? emojies.count : trackerColors.count
        return count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.emoji.text = emojies[indexPath.row]
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? ColorCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.layer.borderColor = UIColor.yWhite.cgColor
            cell.color.backgroundColor = trackerColors[indexPath.row]
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TrackerViewCellHeader
        
        view.titleLabel.text = headersForTrackerCreation[indexPath.section]
        return view
    }
}

extension TrackerCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - 36 - 25
        let cellWidth =  availableWidth / CGFloat(6)
        return CGSize(width: cellWidth,
                      height: cellWidth)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 40, right: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
        CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else {
                return
            }
            if prevSelectedEmojiIndex != nil {
                
                guard let prevSelectedEmojiIndex else { return }
                collectionView.cellForItem(at: prevSelectedEmojiIndex)?.backgroundColor = .clear
            }
            
            cell.backgroundColor = .yLightGray
            cell.layer.cornerRadius = 16
            selectedEmoji = emojies[indexPath.row]
            prevSelectedEmojiIndex = indexPath
            checkIfSaveButtonIsEnabled()
        } else if indexPath.section == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else {
                return
            }
            if prevSelectedColorIndex != nil {
                
                guard let prevSelectedColorIndex else { return }
                collectionView.cellForItem(at: prevSelectedColorIndex)?.layer.borderColor = UIColor.yWhite.cgColor
            }
            
            cell.layer.borderColor = trackerColors[indexPath.row].cgColor
            cell.layer.borderWidth = 3
            cell.layer.cornerRadius = 8
            selectedColor = trackerColors[indexPath.row]
            prevSelectedColorIndex = indexPath
            checkIfSaveButtonIsEnabled()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 {
            
            selectedEmoji = ""
            
        } else if indexPath.section == 1 {
            
            selectedColor = UIColor.clear
        }
    }
}

extension TrackerCreationViewController: CategoryDelegate {
    func sendSelectedCategory(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        checkIfSaveButtonIsEnabled()
        tableView.reloadData()
    }
}
