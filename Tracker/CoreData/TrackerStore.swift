//
//  TrackerStore.swift
//  Tracker
//
//  Created by Andrey Lazarev on 06.07.2024.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func storeDidChange(_ store: TrackerStore) -> Void
}

final class TrackerStore: NSObject {
    let context: NSManagedObjectContext
    
    var trackers: [Tracker] { fetchTracker() }
    
    weak var delegate: TrackerStoreDelegate?
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init()
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        self.fetchedResultController.delegate = self
    }
    
    private lazy var fetchedResultController = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? controller.performFetch()
        return controller
    }()
    
    // конвертируем в кордату норм трекер
    func saveToCoreData(_ obj: Tracker) {
        let coreData = TrackerCoreData(context: context)
        coreData.id = obj.id
        coreData.name = obj.name
        coreData.color = obj.color.toHexString()
        coreData.emoji = obj.emoji
        coreData.schedule = obj.schedule.map {
            $0.rawValue
        }
        try? context.save()
    }
    
    // из кордаты в трекер
    private func toNormalTracker(from coreData: TrackerCoreData) -> Tracker? {
        guard let id = coreData.id,
              let emoji = coreData.emoji,
              let color = coreData.color,
              let name = coreData.name,
              let schedule = coreData.schedule
        else {
            return nil
        }
        return Tracker(id: id,
                       name: name,
                       color: UIColor(hexString: color),
                       emoji: emoji,
                       schedule: schedule.compactMap({ Weekday(rawValue: $0)}))
    }
    
    // из кордаты в норм массив трекеров
    private func fetchTracker() -> [Tracker] {
        guard let objects = fetchedResultController.fetchedObjects else {
            return []
        }
        let result = objects.compactMap({ toNormalTracker(from: $0) })
        return result
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChange(self)
    }
    
}
