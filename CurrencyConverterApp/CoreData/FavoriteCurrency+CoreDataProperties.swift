//
//  FavoriteCurrency+CoreDataProperties.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/13/25.
//
//

import Foundation
import CoreData


extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var currencyCode: String?

}

extension FavoriteCurrency : Identifiable {

}
