//
//  ContentView.swift
//  TaskManager
//
//  Created by Danila Savitsky on 22.09.25.
//

import SwiftUI
import CoreData

struct MainView: View {
    @StateObject var viewModel: MainViewModel = MainViewModel()
    @State var searchText: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TaskItem.entity(),
                  sortDescriptors: [])
    var taskItems: FetchedResults<TaskItem>
    @State var showTaskCreationView: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                DatePickerHeadView(viewModel: viewModel)
                List {
                    ForEach(taskItems, id: \.id) { taskItem in
                        TaskCellView(taskItem)
                    }
                    .onDelete { IndexSet in
                            for index in IndexSet {
                                viewContext.delete(taskItems[index])
                            
                            do {
                                try viewContext.save()
                            } catch { }
                        }
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(0)
                .searchable(text: $searchText, prompt: "search..." )
                .scrollContentBackground(.hidden)
                .navigationTitle("Tasks")
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Menu{
                            Button("Date") {
                                taskItems.nsSortDescriptors = viewModel.buildSortDescriptors(for: "date")
                            }
                            Button("Priority") {
                                taskItems.nsSortDescriptors = viewModel.buildSortDescriptors(for: "priority")
                            }
                            Button("A-Z") {
                                taskItems.nsSortDescriptors = viewModel.buildSortDescriptors(for: "title")
                            }
                            }label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            showTaskCreationView = true
                        } label:{
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showTaskCreationView){
                    TaskCreationView(estimatedDate: viewModel.selectedDate)
                        .environment(\.managedObjectContext, viewContext)
                        
                }
              
                .onChange(of: viewModel.selectedDate){
                    taskItems.nsPredicate = viewModel.buildCompoundPredicate(text: searchText, date: viewModel.selectedDate)
                    print(viewModel.selectedDate)
                }
                .onChange(of: searchText){
                    print(viewModel.selectedDate)
                    taskItems.nsPredicate = viewModel.buildCompoundPredicate(text: searchText, date: viewModel.selectedDate)
                }
                .onAppear(){
                    print(viewModel.selectedDate)
                    taskItems.nsPredicate = viewModel.buildCompoundPredicate(text: searchText, date: viewModel.selectedDate)
                }
            }

           
        }
    }
}

#Preview {
   
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
