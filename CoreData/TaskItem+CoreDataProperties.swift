//
//  TaskItem+CoreDataProperties.swift
//  TaskManager
//
//  Created by Danila Savitsky on 22.09.25.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var priority: Int16
    @NSManaged public var isDone: Bool
    @NSManaged public var date: Date?
    @NSManaged public var details: String?
    @NSManaged public var id: UUID?

}

extension TaskItem : Identifiable {

}
