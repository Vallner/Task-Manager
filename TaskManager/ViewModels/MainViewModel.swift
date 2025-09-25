//
//  MainViewModel.swift
//  TaskManager
//
//  Created by Danila Savitsky on 23.09.25.
//
import Foundation
import SwiftUI
import CoreData

class MainViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    var calendar = Calendar.current
    var date: Date = Date()
    @Published var weekend: [WeekDay] = []
    
    func buildSortDescriptors(for parameter: String) -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: parameter, ascending: true, selector: #selector (NSString.localizedCompare))]
    }
    func buildCompoundPredicate(text: String, date: Date) -> NSCompoundPredicate {
        let firstPredicate = buildPredicateByDate(date: date)
        let secondPredicate = buildPredicateBySearch(text: text)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [firstPredicate, secondPredicate])
    }
    private func buildPredicateBySearch(text: String) -> NSPredicate {
        return text == "" ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", text)
        }
    private func buildPredicateByDate(date: Date) -> NSPredicate {
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
    }
    func getWeekDays(to date: Date)  {
        var daysOfWeek: [WeekDay] = []
        for index in 0..<7 {
            var weekDay = WeekDay()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            let date = calendar.date(byAdding: .day, value: index, to: date)!
            let dateName = calendar.dateComponents([.day], from: date).day!
            weekDay.dateValue = date
            weekDay.name = dateFormatter.string(from: date).uppercased()
            weekDay.dateName = dateName
            daysOfWeek.append(weekDay)
        }
        weekend = daysOfWeek
    }
    func getPreviousWeek()  {
        var daysOfWeek: [WeekDay] = []
        
        for index in -7..<0 {
            var weekDay = WeekDay()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            let date = calendar.date(byAdding: .day, value: index, to: weekend.first!.dateValue)!
            let dateName = calendar.dateComponents([.day], from: date).day!
            weekDay.dateValue = date
            weekDay.name = dateFormatter.string(from: date).uppercased()
            weekDay.dateName = dateName
            daysOfWeek.append(weekDay)
        }
        selectedDate = calendar.date(byAdding: .day, value: -7, to: selectedDate)!
        weekend = daysOfWeek
    }
    func getNextsWeek()  {
        var daysOfWeek: [WeekDay] = []
        for index in 7..<14 {
            var weekDay = WeekDay()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            let date = calendar.date(byAdding: .day, value: index, to: weekend.first!.dateValue)!
            let dateName = calendar.dateComponents([.day], from: date).day!
            weekDay.dateValue = date
            weekDay.name = dateFormatter.string(from: date).uppercased()
            weekDay.dateName = dateName
            daysOfWeek.append(weekDay)
        }
        selectedDate =  calendar.date(byAdding: .day, value: 7, to: selectedDate)!
        weekend = daysOfWeek
    }
    func returnSelectedMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: selectedDate)
    }
    func returnSelectedYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: selectedDate)
    }
    func returnSelectedDayNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: selectedDate)
    }
    init() {
        getWeekDays(to: Date())
    }
}
