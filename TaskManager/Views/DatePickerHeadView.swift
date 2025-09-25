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
            HStack{
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.2)){
                            viewModel.getPreviousWeek()
                        }
                    }
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
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.1)){
                                        viewModel.selectedDate = weekDay.dateValue
                                    }
                                }
                                .background{
                                    if Calendar.current.isDate(weekDay.dateValue, inSameDayAs: viewModel.date) {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 5, height: 5)
                                            .offset(x: 0, y: 30)
                                    }
                                }
                                .offset(x:offset.width / 10)
                        }
                        .frame(maxWidth: .infinity)
                    }
                Image(systemName: "chevron.forward")
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.2)){
                            viewModel.getNextsWeek()
                        }     
                    }
                }
            .transition(.slide)
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        print(offset.width)
                        withAnimation(.snappy(duration: 0.2)){
                            if value.translation.width > 0 {
                                viewModel.getPreviousWeek()
                            }
                            else {
                                viewModel.getNextsWeek()
                            }
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
