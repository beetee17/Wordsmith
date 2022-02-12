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

    @NSManaged public var key_: String?
    @NSManaged public var value_: Int64
    
    var key: String {
        get {
            return key_ ?? "UNKNOWN KEY"
        }
        set {
            key_ = newValue
        }
    }
    
    var value: Int {
        get {
            return Int(value_)
        }
        set {
            value_ = Int64(newValue)
        }
    }
}

extension KeyValuePair : Identifiable {

}
