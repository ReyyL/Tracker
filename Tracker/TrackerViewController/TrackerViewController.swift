//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 02.06.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = []
    
    private var currentDate = Date()
    
    private lazy var visibleCategories: [TrackerCategory] = {
        changeDate()
    }()
    
    var completedTrackers: [TrackerRecord] = []
    
    private lazy var emptyTrackersView = UIView()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    private lazy var starImage = {
        let starImage = UIImageView()
        starImage.image = UIImage(named: "starWhenEmpty")
        starImage.translatesAutoresizingMaskIntoConstraints = false
        return starImage
    }()
    
    private lazy var emptyLabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = "Что будем отслеживать?"
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textColor = .yBlack
        emptyLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return emptyLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupCollection()
        
        loadFromCoreData()
        
        trackerStore.delegate = self
    }
    
    private func loadFromCoreData() {
        trackers = trackerStore.trackers
        completedTrackers = trackerRecordStore.trackerRecords
        categories = [TrackerCategory(title: "Категория", trackersArray: trackers)]
    }
    
    private func setupScreen() {
        
        view.backgroundColor = .yWhite
        
        let plusImageView = UIBarButtonItem(image: UIImage(named: "plusNav"),
                                            style: .plain, target: self,
                                            action: #selector(addTracker))
        plusImageView.tintColor = .yBlack
        navigationItem.leftBarButtonItem = plusImageView
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        let datePickerView = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerView
        
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        
        emptyTrackersView.addSubview(starImage)
        emptyTrackersView.addSubview(emptyLabel)
        
        view.addSubview(emptyTrackersView)
        
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            starImage.topAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            
        ])
    }
    
    private func setupCollection() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TrackerCollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = selectedDate
        updateCollection()
    }
    
    private func changeDate() -> [TrackerCategory] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        
        let stringWeekday: Weekday = {
            switch weekday {
            case 1:
                return .sunday
            case 2:
                return .monday
            case 3:
                return .tuesday
            case 4:
                return .wednesday
            case 5:
                return .thursday
            case 6:
                return .friday
            default:
                return .saturday
            }
        }()
        
        visibleCategories = []
        
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackersArray.filter { tracker in
                
                tracker.schedule.contains(stringWeekday)
            }
            
            if trackers.count > 0 {
                visibleCategories.append(TrackerCategory(title: title, trackersArray: trackers))
            }
        }
        
        emptyTrackersView.isHidden = visibleCategories.isEmpty ? false : true
        collectionView.isHidden = visibleCategories.isEmpty ? true : false
        
        return visibleCategories
    }
    
    @objc private func addTracker() {
        
        let newTrackerController = NewTrackerController()
        newTrackerController.delegate = self
        let navigationNewTrackerController = UINavigationController(rootViewController: newTrackerController)
        
        present(navigationNewTrackerController, animated: true)
    }
}

extension TrackerViewController: CompleteTrackerProtocol {
    func completeTracker(id: UUID, indexPath: IndexPath) {
        let completedTracker = TrackerRecord(id: id, trackerDate: datePicker.date)
        trackerRecordStore.saveToCoreData(completedTracker)
        completedTrackers.append(completedTracker)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            
            let isSameDay = Calendar.current.isDate(trackerRecord.trackerDate, inSameDayAs: datePicker.date)
            if trackerRecord.id == id && isSameDay {
                trackerRecordStore.deleteFromCoreData(trackerRecord)
                return true
            }
            return false
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func isTrackerComplete(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.trackerDate, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        cell.prepareForReuse()
        let tracker = visibleCategories[indexPath.section].trackersArray[indexPath.row]
        
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        cell.delegate = self
        let isCompleted = isTrackerComplete(id: tracker.id)
        
        cell.configureCell(tracker: tracker, completedDays: completedDays, isTrackerCompleted: isCompleted, indexPath: indexPath)
        
        if datePicker.date > Date() {
            cell.plusButton.isHidden = true
        } else {
            cell.plusButton.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TrackerViewCellHeader
        
        view.titleLabel.text = categories[indexPath.section].title
        return view
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - 32 - 9
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

extension TrackerViewController: TrackerCreationDelegete {
    func createTracker(tracker: Tracker) {
        
        let category = "Категория"
        
        let categoryFound = categories.filter { $0.title == category }
        
        trackerStore.saveToCoreData(tracker)
        var trackers: [Tracker] = []
        if categoryFound.count > 0 {
            categoryFound.forEach { trackers = trackers + $0.trackersArray }
            
            trackers.append(tracker)
            
            categories = categories.filter { $0.title != category }
            
            if !trackers.isEmpty {
                let newCategory = TrackerCategory(title: category, trackersArray: trackers)
                categories.append(newCategory)
            }
            
        } else {
            let newSoloTracker = TrackerCategory(title: category, trackersArray: [tracker])
            categories.append(newSoloTracker)
        }
        
        updateCollection()
    }
    
    private func updateCollection() {
        visibleCategories = changeDate()
        collectionView.reloadData()
    }
}

extension TrackerViewController: TrackerStoreDelegate {
    
    func storeDidChange(_ store: TrackerStore) {
        trackers = trackerStore.trackers
        collectionView.reloadData()
    }
}



