//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Andrey Lazarev on 15.07.2024.
//

import UIKit

final class CategoriesViewModel {
    
    weak var delegate: CategoryDelegate?
    
    var categories = [String]()
    
    private let trackerCategoryStore = TrackerCategoryStore()
   
    func loadCategories() {
        let textCategories = trackerCategoryStore.trackerCategories.map { $0.title }
        categories = textCategories
    }
    
    func sendCategoryAfterTap(indexPath: IndexPath) {
        delegate?.sendSelectedCategory(selectedCategory: categories[indexPath.row] )
    }
    
}
