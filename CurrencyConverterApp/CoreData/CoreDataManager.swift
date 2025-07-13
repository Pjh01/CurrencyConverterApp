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
  //static let shared = CoreDataManager()
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
  
  func getExchangeRate(for currencyCode: String) -> (currencyCode: String, rate: Double, changeStatus: String, timeStamp: Date) {
    let request: NSFetchRequest<ExchangeRateStatus> = ExchangeRateStatus.fetchRequest()
    request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
    
    if let exchangeRateItem = try? context.fetch(request).first {
      return (
        currencyCode: exchangeRateItem.currencyCode ?? "",
        rate: exchangeRateItem.rate,
        changeStatus: exchangeRateItem.changeStatus ?? "",
        timeStamp: exchangeRateItem.timeStamp ?? Date())
    } else {
      return (
        currencyCode: currencyCode,
        rate: mockData[currencyCode] ?? 0.0,
        changeStatus: "",
        timeStamp: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date())
    }
  }
  
  func updateExchangeRate(
    currencyCode: String,
    rate: Double,
    changeStatus: String,
    timeStamp: Date
  ) {
    let request: NSFetchRequest<ExchangeRateStatus> = ExchangeRateStatus.fetchRequest()
    request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
    
    if let exchangeRateItem = try? context.fetch(request).first {
      exchangeRateItem.rate = rate
      exchangeRateItem.changeStatus = changeStatus
      exchangeRateItem.timeStamp = timeStamp
    } else {
      let newExchangeRateItem = ExchangeRateStatus(context: context)
      newExchangeRateItem.currencyCode = currencyCode
      newExchangeRateItem.rate = rate
      newExchangeRateItem.changeStatus = changeStatus
      newExchangeRateItem.timeStamp = timeStamp
    }
    saveContext()
  }
  
//  func getLatestTimeStamp() -> Date? {
//      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ExchangeRateStatus")
//      request.resultType = .dictionaryResultType
//      request.propertiesToFetch = ["timeStamp"]
//      request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
//      request.fetchLimit = 1
//
//      do {
//          if let result = try context.fetch(request).first as? [String: Any],
//             let timeStamp = result["timeStamp"] as? Date {
//              return timeStamp
//          }
//      } catch {
//          print("Failed to fetch latest timeStamp: \(error)")
//      }
//
//      return nil
//  }
  
  private func saveContext() {
    if context.hasChanges {
      do {
        //print("\(context)")
        try context.save()
      } catch {
        print("core data save error: \(error)")
      }
    }
  }
  
  
}
