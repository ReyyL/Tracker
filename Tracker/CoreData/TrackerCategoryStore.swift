//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Andrey Lazarev on 06.07.2024.
//

import UIKit
import CoreData

/// Файл на будущее для реализации разных категорий?

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidChange(_ store: TrackerCategoryStore) -> Void
}

final class TrackerCategoryStore: NSObject {
    let context: NSManagedObjectContext
    
    let trackerStore = TrackerStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategory] { fetchTrackerCategory() }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    convenience override init() {
        self.init(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        
    }
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    // делаем из категорий в кор дате норм категории
    func fetchTrackerCategory() -> [TrackerCategory] {
        
        guard let objects = fetchedResultController.fetchedObjects else {
            return []
        }
        
        let trackers = objects.compactMap({ trackerCategory(from: $0) })
        
        return trackers
    }
    
    //конвертируем и сохраняем в кор дату переданную категорию трекеров
    func saveToCoreData(_ obj: TrackerCategory) {
        let coreData = TrackerCategoryCoreData(context: context)
        coreData.title = obj.title
        coreData.trackers = NSSet(array: [])
        try? context.save()
    }
    
    //ищем в кор дате категории трекеров с нужным заголовком
    private func findCoreDataTitle(with title: String) -> TrackerCategoryCoreData? {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title as CVarArg)
        let result = try? context.fetch(fetchRequest)
        return result?.first
    }
    
    // в трекеры конкретной категории в кордате добавляем норм категории
    func addToCoreDataCategory(with title: String, tracker: Tracker) {
        let trackers = trackerStore.getCoreDataTrackers()
        guard let coreData = findCoreDataTitle(with: title) else {
            fatalError()
        }
        var existingTrackers = coreData.trackers?.allObjects as? [TrackerCoreData] ?? []
        if let index = trackers.firstIndex(where: {$0.id == tracker.id}) {
            existingTrackers.append(trackers[index])
        }
        coreData.trackers = NSSet(array: existingTrackers)
        try? context.save()
    }
    
    func addCategoryTitleToCoreData(title: String) {
        
    }
    
    // делаем из кордаты норм категории трекеров
    private func trackerCategory(from coreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard
            let title = coreData.title,
            let trackers = coreData.trackers
        else {
            return nil
        }
//        print(title)
        let result = TrackerCategory(
            title: title,
            trackersArray:  trackers.compactMap { coreDataTracker -> Tracker? in
                if let coreDataTracker = coreDataTracker as? TrackerCoreData {
                    return trackerStore.toNormalTracker(from: coreDataTracker)
                }
                return nil
            }
        )
        return result
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChange(self)
    }
    
}
