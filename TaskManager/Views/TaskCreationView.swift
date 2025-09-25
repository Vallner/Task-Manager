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
    var task: TaskItem?
    @State var title: String
    @State var description:String
    @State var estimatedDate:Date
    @State var priority: Int = 0
   
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
                    guard task == nil else {
                        task?.title = title
                        task?.date = estimatedDate
                        task?.details = description
                        task?.isDone = false
                        task?.priority = Int16(priority)
                        try? viewContext.save()
                        dismiss()
                        return
                    }
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
            TextField("Enter task title...", text: $title)
                .padding()
                .background(content: { RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)) })
            DatePicker("Estimated date", selection: $estimatedDate)
                .datePickerStyle(.compact)
                .padding(.vertical)
                .foregroundStyle(.secondary)
            Text("Description")
                .font(.title)
                .fontWeight(.bold)
            TextField("Type description of a task here...", text: $description, axis: .vertical)
                .frame(height:400, alignment: .top)
                .padding()
                .background{
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        
                }
              
           
               
            Spacer()
            
        }
        .padding(.horizontal)
        .presentationDetents([.large])
        .presentationBackground(.ultraThinMaterial)
    }

}
extension TaskCreationView {
    init( _ task: TaskItem) {
        self.task = task
        self.estimatedDate = task.date!
        self.description = task.details!
        self.title = task.title!
        self.priority = Int(task.priority)
        
        print("Created using a task")
    }
    
}

#Preview {
    TaskCreationView(title: "", description: "",estimatedDate: Date())
}
