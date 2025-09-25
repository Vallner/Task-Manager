//
//  DatePickerHeadView.swift
//  TaskManager
//
//  Created by Danila Savitsky on 22.09.25.
//

import SwiftUI

struct DatePickerHeadView: View {
    @ObservedObject var viewModel:MainViewModel
    var weekend: [WeekDay]
    @State private var offset = CGSize.zero
    init(viewModel:MainViewModel) {
        self.viewModel = viewModel
        self.weekend = viewModel.weekend
    }
    
    var body: some View {
        
        VStack{
//            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center,spacing: 20){
                    ForEach(weekend,id: \.self){ weekDay in
                        VStack{
                            Text(weekDay.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(weekDay.dateName)")
                                .frame(width: 40, height: 40)
                                .background( Calendar.current.isDate(weekDay.dateValue, inSameDayAs: viewModel.selectedDate) ? Color.blue : Color.white)
                                .foregroundStyle(Calendar.current.isDate(weekDay.dateValue, inSameDayAs: viewModel.selectedDate) ? Color.white : Color.black)
                                .clipShape(Circle())
                                .padding(.bottom)
                                .onTapGesture {
                                    withAnimation(.snappy){
                                        viewModel.selectedDate = weekDay.dateValue
                                    }
                                }
                        }
                    }
//                }
                }
            .offset(x: offset.width )
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        print(offset.width)
                        
                        if offset.width > 0 {
                            viewModel.getPreviousWeek()
                            
                        }
                        else {
                            viewModel.getNextsWeek()
                        }
                        offset = .zero
                       
                        print("done")
                        
                    }
            )
            .animation(.spring(),value: offset)
        }
    }

}

#Preview {
    let viewModel = MainViewModel()
    DatePickerHeadView(viewModel: viewModel)
}
