//
//  CoreDataManager.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/13/25.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
  static let shared = CoreDataManager()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  func addFavorite(_ code: String) {
    let entity = FavoriteCurrency(context: context)
    entity.currencyCode = code
    saveContext()
  }
  
  func removeFavorite(_ code: String) {
    let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    request.predicate = NSPredicate(format: "currencyCode == %@", code)
    
    if let favoriteItems = try? context.fetch(request) {
      favoriteItems.forEach { context.delete($0) }
      saveContext()
    }
  }
  
  func loadFavorites() -> [String] {
    let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    let favoriteItems = try? context.fetch(request)
    return favoriteItems?.compactMap { $0.currencyCode } ?? []
  }
  
  private func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print("core data save error: \(error)")
      }
    }
  }
}
