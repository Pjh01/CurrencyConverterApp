//
//  LastVisitedScreen+CoreDataProperties.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/14/25.
//
//

import Foundation
import CoreData


extension LastVisitedScreen {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<LastVisitedScreen> {
    return NSFetchRequest<LastVisitedScreen>(entityName: "LastVisitedScreen")
  }
  
  @NSManaged public var currencyCode: String?
  @NSManaged public var screenType: String?
  
}

extension LastVisitedScreen : Identifiable {
  
}
