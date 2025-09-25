//
//  WeekDayModel.swift
//  TaskManager
//
//  Created by Danila Savitsky on 24.09.25.
//
import Foundation


struct WeekDay:Hashable {
    var id: UUID = .init()
    var name: String = ""
    var dateName: Int = 0
    var dateValue: Date = Date()
    var containsAtasks: Bool = false
}
