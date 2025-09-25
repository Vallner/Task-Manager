//
//  TaskCreationView.swift
//  TaskManager
//
//  Created by Danila Savitsky on 22.09.25.
//

import SwiftUI

struct TaskCreationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State var title = ""
    @State var description = ""
    @State var estimatedDate:Date
    @State var priority = 0
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Button{
                    dismiss()
                }label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
                Spacer()
                Button{
                    let newTask = TaskItem(context: viewContext)
                    newTask.title = title
                    newTask.details = description
                    newTask.isDone = false
                    newTask.priority = Int16(priority)
                    newTask.date = estimatedDate
                    newTask.id = UUID()
                    try? viewContext.save()
                    dismiss()
                }label: {
                    Text("Save")
                }
            }
            .padding()
            Text("Title")
                .font(.title)
                .fontWeight(.bold)
            TextField("Enter task title", text: $title)
                .padding(.horizontal)
            DatePicker("Estimated date", selection: $estimatedDate)
                .padding()
            Text("Description")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Enter task description", text: $description)
                .padding(.horizontal)
            Spacer()
            
        }
        .padding(.horizontal)
        .presentationDetents([.medium])
        .presentationBackground(.ultraThinMaterial)
    }

}

#Preview {
    TaskCreationView(estimatedDate: Date())
}
