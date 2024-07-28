//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Andrey Lazarev on 06.07.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    let context: NSManagedObjectContext
    
    var trackerRecords: [TrackerRecord] { fetchTrackerRecords() }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    convenience override init() {
        self.init(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        
    }
    
    // сохраняем в кордату норм запись трекеров
    func saveToCoreData(_ obj: TrackerRecord) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else { return }
        let coreData = TrackerRecordCoreData(entity: entity, insertInto: context)
        coreData.id = obj.id
        coreData.date = obj.trackerDate
        try? context.save()
    }
    
    // удаляем объект в кордате по конкретному айди
    func deleteFromCoreData(_ obj: TrackerRecord) {
        guard let coreData = findCoreDataId(for: obj) else {
            return
        }
        context.delete(coreData)
        try? context.save()
    }
    
    // из кор даты в норм запись
    private func trackerRecord(from coredData: TrackerRecordCoreData) -> TrackerRecord? {
        guard
            let id = coredData.id,
            let date = coredData.date else
        {
            return nil
        }
        return TrackerRecord(id: id, trackerDate: date)
    }
    
    // ищем в кордате запись трекеров с нужным айди
    private func findCoreDataId(for obj: TrackerRecord) -> TrackerRecordCoreData? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", obj.id as CVarArg)
        let result = try? context.fetch(fetchRequest)
        return result?.first
    }
    
    // конвертируем из кордаты в норм запись
    func fetchTrackerRecords() -> [TrackerRecord] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let trackerRecordCoreDataArray = try! managedContext.fetch(fetchRequest)
        
        let result = trackerRecordCoreDataArray.compactMap({ trackerRecord(from: $0) })
        
        return result
    }
}

