//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 02.06.2024.
//


import UIKit
import YandexMobileMetrica

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
    
    private var tempCategories = [TrackerCategory]()
    
    private var currentFilter = "Все трекеры"
    
    private var isSearch = false
    
    var completedTrackers: [TrackerRecord] = []
    
    private lazy var emptyTrackersView = UIView()
    
    private lazy var notFoundView = UIView()
    
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
    
    private lazy var notFoundImage = {
        let starImage = UIImageView()
        starImage.image = UIImage(named: "notFound")
        starImage.translatesAutoresizingMaskIntoConstraints = false
        return starImage
    }()
    
    private lazy var notFoundLabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = NSLocalizedString("not_found", comment: "")
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textColor = .yBlack
        emptyLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return emptyLabel
    }()
    
    private lazy var starImage = {
        let starImage = UIImageView()
        starImage.image = UIImage(named: "starWhenEmpty")
        starImage.translatesAutoresizingMaskIntoConstraints = false
        return starImage
    }()
    
    private lazy var emptyLabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = NSLocalizedString("what_track", comment: "")
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textColor = .yBlack
        emptyLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return emptyLabel
    }()
    
    private lazy var filtersButton = {
        let title = NSLocalizedString("filters", comment: "")
        let filtersButton = Button(title: title, backColor: .yBlack, textColor: .yWhite)
        filtersButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        filtersButton.backgroundColor = .yBlue
        filtersButton.addTarget(self, action: #selector(openFilters), for: .touchUpInside)
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        return filtersButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupCollection()
        
        loadFromCoreData()
        
        trackerStore.delegate = self
        
        sendAnalytics(mainEvent: "main_page", event: "open", screen: "Main", item: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sendAnalytics(mainEvent: "main_page", event: "close", screen: "Main", item: nil)
    }
    
    private func sendAnalytics(mainEvent: String, event: String, screen: String, item: String?) {
        let params : [AnyHashable : Any] = ["event" : event, "screen": screen, "item": item]
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    private func loadFromCoreData() {
        trackers = trackerStore.trackers
        completedTrackers = trackerRecordStore.trackerRecords
        categories = trackerCategoryStore.trackerCategories
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
        
        navigationController?.navigationBar.backgroundColor = .yWhite
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yBlack]
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        
        emptyTrackersView.addSubview(starImage)
        emptyTrackersView.addSubview(emptyLabel)
        
        notFoundView.addSubview(notFoundImage)
        notFoundView.addSubview(notFoundLabel)
        notFoundView.isHidden = true
        
        view.addSubview(emptyTrackersView)
        view.addSubview(notFoundView)
        
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            starImage.topAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            notFoundImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            notFoundImage.topAnchor.constraint(equalTo: view.centerYAnchor),
            notFoundLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            notFoundLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupCollection() {
        
        collectionView.contentInset.bottom = 70
        
        collectionView.backgroundColor = .yWhite
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TrackerCollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackerViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            
        ])
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = selectedDate
        updateCollection()
    }
    
    @objc private func openFilters() {
        sendAnalytics(mainEvent: "filter_tap", event: "click", screen: "Main", item: "filter")
        let filterController = FilterController()
        let navigationFilterController = UINavigationController(rootViewController: filterController)
        filterController.currentFilter = currentFilter
        filterController.delegate = self
        present(navigationFilterController, animated: true)
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
        isSearch = false
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
        
        filtersButton.isHidden = collectionView.isHidden ? true : false
        
        if tempCategories.isEmpty, isSearch {
            notFoundView.isHidden = false
            collectionView.isHidden = true
        }
        
        if !notFoundView.isHidden {
            emptyTrackersView.isHidden = true
            filtersButton.isHidden = false
        }
        
        return visibleCategories
    }
    
    @objc private func addTracker() {
        
        sendAnalytics(mainEvent: "add_tracker", event: "click", screen: "Main", item: "add_track")
        let newTrackerController = NewTrackerController()
        newTrackerController.delegate = self
        let navigationNewTrackerController = UINavigationController(rootViewController: newTrackerController)
        
        present(navigationNewTrackerController, animated: true)
    }
}

//MARK: - Tracker Completion
extension TrackerViewController: CompleteTrackerProtocol {
    func completeTracker(id: UUID, indexPath: IndexPath) {
        sendAnalytics(mainEvent: "complete_tracker", event: "click", screen: "Main", item: "track")
        let completedTracker = TrackerRecord(id: id, trackerDate: datePicker.date)
        trackerRecordStore.saveToCoreData(completedTracker)
        completedTrackers.append(completedTracker)
        collectionView.reloadData()
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

//MARK: - CollectionCreate
extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        isSearch ? tempCategories.count : visibleCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        isSearch ? tempCategories[section].trackersArray.count : visibleCategories[section].trackersArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        cell.prepareForReuse()
        let tracker = isSearch ? tempCategories[indexPath.section].trackersArray[indexPath.row] : visibleCategories[indexPath.section].trackersArray[indexPath.row]
        
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TrackerViewCellHeader
        
        view.titleLabel.text = isSearch ? tempCategories[indexPath.section].title : visibleCategories[indexPath.section].title
        return view
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - 32 - 9
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
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
    
    
    
    // MARK: - Context Menu
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemsAt indexPath: [IndexPath],
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard indexPath.count > 0 else { return nil}
        
        lazy var tracker = self.visibleCategories[indexPath[0].section].trackersArray[indexPath[0].row]
        
        return UIContextMenuConfiguration(actionProvider: {
            suggestedActions in
            let pinAction =
            UIAction(title: NSLocalizedString("pin", comment: "")) { action in
                self.pinTracker(indexPath: indexPath[0])
            }
            let unpinAction =
            UIAction(title: NSLocalizedString("unpin", comment: "")) { action in
                self.pinTracker(indexPath: indexPath[0])
            }
            let editAction =
            UIAction(title: NSLocalizedString("edit", comment: "")) { action in
                self.editTracker(tracker: tracker,
                                 completedDays: self.completedTrackers.filter { $0.id == tracker.id }.count)
            }
            let deleteAction =
            UIAction(title: NSLocalizedString("delete", comment: ""),
                     attributes: .destructive) { action in
                self.deleteTracker(indexPath: indexPath[0])
            }
            
            if self.visibleCategories[indexPath[0].section].title == NSLocalizedString("pinned_title", comment: "") {
                return UIMenu(title: "", children: [unpinAction, editAction, deleteAction])
            } else {
                return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        let parameters = UIPreviewParameters()
        let previewView = UITargetedPreview(view: cell.bodyView, parameters: parameters)
        return previewView
    }
    
    func pinTracker(indexPath: IndexPath) {
        
        let pinnedTitle = NSLocalizedString("pinned_title", comment: "")
        let pinnedCategory = categories.filter { $0.title == pinnedTitle }
        let currentTracker = visibleCategories[indexPath.section].trackersArray[indexPath.row]
        let currentCategory = visibleCategories[indexPath.section].title
        
        if currentCategory == pinnedTitle {
            trackerCategoryStore.deleteFromCoreData(with: pinnedTitle, tracker: currentTracker)
            trackerCategoryStore.addToCoreDataCategory(with: currentTracker.category, tracker: currentTracker)
        } else {
            if pinnedCategory.count == 0 {
                trackerCategoryStore.addCategoryTitleToCoreData(title: pinnedTitle)
            }
            trackerCategoryStore.deleteFromCoreData(with: visibleCategories[indexPath.section].title, tracker: currentTracker)
            trackerCategoryStore.addToCoreDataCategory(with: pinnedTitle, tracker: currentTracker)
        }
        loadFromCoreData()
        updateCollection()
    }
    
    func editTracker(tracker: Tracker, completedDays: Int) {
        sendAnalytics(mainEvent: "edit_tracker", event: "click", screen: "Main", item: "edit")
        let editViewController = EditTrackerViewController()
        editViewController.delegate = self
        
        editViewController.getDataForEdit(tracker: tracker, completedDays: completedDays)
        let navigationEditController = UINavigationController(rootViewController: editViewController)
        present(navigationEditController, animated: true)
    }
    
    func deleteTracker(indexPath: IndexPath) {
        sendAnalytics(mainEvent: "delete_tracker", event: "click", screen: "Main", item: "delete")
        trackerCategoryStore.deleteFromCoreData(with: visibleCategories[indexPath.section].title, tracker: visibleCategories[indexPath.section].trackersArray[indexPath.row])
        trackerStore.deleteFromCoreData(id: visibleCategories[indexPath.section].trackersArray[indexPath.row].id)
        loadFromCoreData()
        updateCollection()
    }
}

//MARK: - Creation
extension TrackerViewController: TrackerCreationDelegete {
    func createTracker(tracker: Tracker) {
        
        let categoryFound = categories.filter { $0.title == tracker.category }
        
        var isComingTrackerExists = trackers.filter { currentTracker in
            currentTracker.id == tracker.id
        }
        
        if let existingTracker = isComingTrackerExists.first {
            
            isComingTrackerExists.removeAll()
            trackerStore.deleteFromCoreData(id: existingTracker.id)
        }
        
        trackerStore.saveToCoreData(tracker)
        var trackers: [Tracker] = []
        if categoryFound.count > 0 {
            categoryFound.forEach { trackers = trackers + $0.trackersArray }
            
            trackers.append(tracker)
            
            categories = categories.filter { $0.title != tracker.category }
            
            if !trackers.isEmpty {
                let newCategory = TrackerCategory(title: tracker.category, trackersArray: trackers)
                
                categories.append(newCategory)
            }
            
        } else {
            let newSoloTracker = TrackerCategory(title: tracker.category, trackersArray: [tracker])
            categories.append(newSoloTracker)
        }
        
        trackerCategoryStore.addToCoreDataCategory(with: tracker.category, tracker: tracker)
        loadFromCoreData()
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

//MARK: - Filter

extension TrackerViewController: FilterControllerDelegate {
    
    func filterTrackers(filter: String) {
        
        var tempTrackers = [Tracker]()
        var result = [TrackerCategory]()
        currentFilter = filter
        switch filter {
        case "Все трекеры":
            isSearch = false
            updateCollection()
        case "Трекеры на сегодня":
            isSearch = false
            datePicker.date = Date()
            datePickerValueChanged(datePicker)
        case "Завершенные":

            updateCollection()
            visibleCategories.forEach { category in
                tempTrackers = category.trackersArray.filter { tracker in
                    
                    isTrackerComplete(id: tracker.id)
                }
                if !tempTrackers.isEmpty {
                    
                    result.append(TrackerCategory(title: category.title, trackersArray: tempTrackers))
                }
            }
            if result.isEmpty {
                notFoundView.isHidden = false
                collectionView.isHidden = true
            }
            isSearch = true
            tempCategories = result
            
        case "Не завершенные":
            
            updateCollection()
            visibleCategories.forEach { category in
                tempTrackers = category.trackersArray.filter { tracker in
                    
                    !isTrackerComplete(id: tracker.id)
                }
                
                if !tempTrackers.isEmpty {
                    
                    result.append(TrackerCategory(title: category.title, trackersArray: tempTrackers))
                }
            }
            
            if result.isEmpty {
                notFoundView.isHidden = false
                collectionView.isHidden = true
            }
            
            tempCategories = result
            isSearch = true
        default:
            break
        }
        
        collectionView.reloadData()
    }
}

//MARK: - SearchController

extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var result = [TrackerCategory]()
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            isSearch = true
            
            var tempTrackers = [Tracker]()
            
            visibleCategories.forEach { category in
                tempTrackers = category.trackersArray.filter { tracker in
                    tracker.name.lowercased().contains(searchText.lowercased())
                }
                
                if !tempTrackers.isEmpty {
                    
                    result.append(TrackerCategory(title: category.title, trackersArray: tempTrackers))
                }
            }
            
            notFoundView.isHidden = !result.isEmpty
            collectionView.isHidden = result.isEmpty
            
        } else {
            loadFromCoreData()
            result = visibleCategories
        }
        
        tempCategories = result
        collectionView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        isSearch = false
        loadFromCoreData()
        updateCollection()
        collectionView.reloadData()
    }
}



