//
//  KeyValuePair+CoreDataProperties.swift
//  Wordsmith
//
//  Created by Brandon Thio on 12/2/22.
//
//

import Foundation
import CoreData


extension KeyValuePair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KeyValuePair> {
        return NSFetchRequest<KeyValuePair>(entityName: "KeyValuePair")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: Int64

}

extension KeyValuePair : Identifiable {

}
