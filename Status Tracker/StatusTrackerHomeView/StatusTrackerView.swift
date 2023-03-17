//
//  ContentView.swift
//  Status Tracker
//
//  Created by Guru Mahan on 13/03/23.
//

import SwiftUI

struct StatusTrackerView: View {
    @StateObject var viewModel = SheetViewModel()
    @State var itemIndex:Int?
    @State var text = ""
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack{
            VStack{
                ZStack(alignment: .top){
                    backGroundColoView
                        .cornerRadius(20)
                    scrollView
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .padding(.top,250)
                    if viewModel.showDateList{
                        ScrollView{
                            ForEach(0..<(viewModel.dataList?.items?.count ?? 0 ),id: \.self ){ index in
                                dateDropdownView(index: index)
                            }
                            .padding(.top,10)
                        }.frame(height: 280)
                            .background(Color(hex: "#C4A484"))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#7B3F00"), lineWidth: 5))
                        
                            .padding(.leading,10)
                            .padding(.trailing,150)
                            .padding(.top,140)
                    }
                }.ignoresSafeArea()
                Spacer()
                submitView
            }
            .ignoresSafeArea()
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.viewModel.getData()
            }
          
        }
        .loader(isShown: $viewModel.isLoader)
    }
    
    @ViewBuilder var backGroundColoView: some View {
        ZStack{
            Color(hex: "#300A60")
            ZStack{
                HStack{
                    Spacer()
                    Image("msgBox").foregroundColor(.white)
                    Image("verifiedMsg")
                }
                .padding(.bottom,160)
                .padding(.trailing,20)
                ZStack{
                    VStack(alignment: .leading,spacing: 0){
                        HStack{
                            TitleView
                            Spacer()
                            Image("HeaderLogo")
                                .resizable()
                                .frame(width: 150,height: 150)
                                .padding(.top,30)
                        }
                    }.padding()
                }
            }
        }.frame(maxWidth: .infinity,maxHeight: 351)
    }
    
    @ViewBuilder var TitleView: some View {
        ZStack {
            VStack{
                HStack{
                    Button {
                        viewModel.showDateList.toggle()
                        
                    } label: {
                        Text("\(viewModel.changedDay ?? "")").foregroundColor(.white)
                            .underline()
                    }
                }
                VStack(alignment: .trailing){
                    Text(" Welcome,").fontWeight(.bold) .foregroundColor(.white)
                    Text("Team!").fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }.padding(.bottom,55)
    }
    
    @ViewBuilder func dateDropdownView(index: Int) -> some View {
        VStack(alignment: .leading){
            Text(viewModel.dateFormate(date:  viewModel.dataList?.items?[index].date ?? ""))
                .padding(.leading,5)
                .font(.callout)
                .background(Color(hex: "#C4A484"))
                .foregroundColor(.white)
                .onTapGesture {
                    viewModel.changedDay = viewModel.dateFormate(date:  viewModel.dataList?.items?[index].date ?? "")
                    viewModel.showDateList = false
                    
                    if let filteredData = viewModel.dataList?.items {
                        for datum in filteredData where datum.date == viewModel.dataList?.items?[index].date ?? "" {
                            viewModel.filteredItems = datum.datas ?? []
                            viewModel.textFields = datum.datas ?? []
                            viewModel.textFields = viewModel.valueMapDataElement()
                        }
                    }
                }
            Divider()
        }
    }
    
    @ViewBuilder var scrollView: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading,spacing: 10) {
                ForEach(0..<(viewModel.textFields.count ) ,id: \.self){ index in
                    HStack(spacing: 0){
                        ZStack{
                            Color(hex: viewModel.leftSideDividerColorCode(index: index))
                            HStack{
                                leftSideDividerView
                                    .frame(width: 1)
                                listSheetView( index: index)
                            }.padding(.leading,0)
                        }
                    }
                    .padding(5)
                    .cornerRadius(30)
                }
            }
            .padding()
        }.refreshable {
            viewModel.getData()
        }
    }
    
    @ViewBuilder var leftSideDividerView: some View{
        ZStack{
        }
    }
    
    @ViewBuilder func listSheetView(index: Int) ->  some View {
        let datas = viewModel.dataList?.items?.last?.datas?[index]
        ZStack{
            HStack{
                VStack(spacing: 0){
                    HStack{
                        Image(systemName: "person.fill").foregroundColor(.white)
                        Text("\(datas?.name ?? "")").foregroundColor(.white)
                        Spacer()
                    }.padding()
                        .background(Color(hex: viewModel.nameViewColorCode(index:index)))
                    VStack(alignment: .leading){
                        
                        VStack(alignment: .leading){
                            TextEditorView(text: $viewModel.textFields[index].text, placeHolder: "Enter.....", index: index, viewModel: viewModel)
                        }.padding()
                    }.frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background(Color(hex: viewModel.detailsColorCode(index:index)))
                }
            }
            .background(Color(hex: "#E1D5D4"))
        }
    }
    
    @ViewBuilder var submitView: some View{
        VStack{
            Button {
                
            } label: {
                Text("Submit")
                    .fontWeight(.bold)
                    .frame(height: 40)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#300A60"))
                    .cornerRadius(20)
            }
            .padding(.leading)
            .padding(.trailing)
        }
        .padding(.bottom,10)
    }
    
    @ViewBuilder func customTextEditor(placeholder:String,index:Int) -> some View {
        ZStack(alignment: .topLeading){
            if text.isEmpty{
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(5)
            }
            TextEditor(text: $viewModel.textFields[index].text )
                .background(Color(hex: viewModel.detailsColorCode(index:index)))
            
        }
        .onAppear{
            UITextView.appearance().backgroundColor = .red
        }
        .onDisappear{
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct TextEditorView: View {
    @Binding var text: String
    var placeHolder:String?
    var index: Int
    var viewModel:SheetViewModel
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeHolder ?? "")
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(5)
            }
                TextEditor(text: $text)
                    .background(Color(hex: viewModel.detailsColorCode(index:index)))
                    .scrollContentBackground(.hidden)
          
        }.onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StatusTrackerView()
    }
}

//Edit - square.and.pencil
//Done - app.badge.checkmark.fill
