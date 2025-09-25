//
//  TaskCellView.swift
//  TaskManager
//
//  Created by Danila Savitsky on 22.09.25.
//

import SwiftUI
import Foundation
struct TaskCellView: View {
    @ObservedObject var task: TaskItem
    init(_ task: TaskItem) {
        self.task = task
    }
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    var body: some View {
        HStack(alignment: .bottom){
            VStack(alignment: .leading) {
                Text(task.title ?? "No title")
                    .font(.headline)
                    .lineLimit(1)
                Text(task.details ?? "No details")
                    .font(.caption)
                    .lineLimit(1)
            }
            Spacer()
            Text("Estimated date:\(dateFormatter.string(from: task.date ?? Date()))")
                .font(.system(size: 11, weight: .light , design: .monospaced))
            
        }
        .listRowSeparator(.hidden)
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        }
        .padding(-7)
       
        
       
    }
}

struct DisplayDish_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    let task = TaskItem(context: context)
    static var previews: some View {
        TaskCellView(oneTask())
    }
    static func oneTask() -> TaskItem {
        let task = TaskItem(context: context)
        task.title = "Hummus"
        task.id = UUID()
        task.details = "SpicySpicy Spicy Spicy Spicy Spicy Spicy Spicy Spicy Spicy Spicy"
        task.date = Date()
        task.isDone = false
        task.priority = 1
        return task
    }
}
