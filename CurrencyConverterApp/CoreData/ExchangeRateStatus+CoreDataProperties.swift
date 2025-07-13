//
//  ExchangeRateStatus+CoreDataProperties.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/14/25.
//
//

import Foundation
import CoreData


extension ExchangeRateStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRateStatus> {
        return NSFetchRequest<ExchangeRateStatus>(entityName: "ExchangeRateStatus")
    }

    @NSManaged public var timeStamp: Date?
    @NSManaged public var currencyCode: String?
    @NSManaged public var rate: Double
    @NSManaged public var changeStatus: String?

}

extension ExchangeRateStatus : Identifiable {

}
