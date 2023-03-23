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
    @State var isShowAlertPopUP = false
    @State var isShow = false
    
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
            if isShowAlertPopUP {
                withAnimation(.easeIn(duration: 1.0)) {
                    AlertView(isCanclePopUp: $isShowAlertPopUP, isShowSelectedMembers: $isShow)
                }
            }
            
            VStack{
                Spacer()
                IndividualMemberPopUpView(viewModel: viewModel).offset(y: self.isShow ? 0 : UIScreen.main.bounds.height)
            }.background((self.isShow ? Color.black.opacity(0.3) : Color.clear))
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)){
                        self.isShow.toggle()
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
        }
        .hideKeyboardWhenTappedAround()
        .onAppear{
            self.viewModel.getData()
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
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.2)) {
                                isShowAlertPopUP = true
                            }
                        }
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
                        withAnimation(.easeIn(duration: 0.2)){
                            viewModel.showDateList.toggle()
                        }
                    } label: {
                        Text("\(viewModel.changedDay ?? "")")
                            .foregroundColor(.white)
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
                    viewModel.updateDateFormate(date:viewModel.dataList?.items?[index].date ?? "")
                    if let filteredData = viewModel.dataList?.items {
                        for datum in filteredData where datum.date == viewModel.dataList?.items?[index].date ?? "" {
                            viewModel.filteredItems = datum.datas ?? []
                            viewModel.textFields = datum.datas ?? []
                            viewModel.textFields = viewModel.taskTextMapDataElement()
                            // viewModel.textFields = viewModel.updateValueMapDataElement()
                            print("====>\(viewModel.taskTextMapDataElement())")
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
                        withAnimation(.easeIn(duration: 0.2)){
                            ZStack{
                                Color(hex: viewModel.taskListLeftCornerColorCode(index: index))
                                HStack{
                                    leftSideDividerView
                                        .frame(width: 1)
                                    listSheetView( index: index)
                                }.padding(.leading,0)
                            }
                        }
                        
                    }
                    .padding(5)
                    .cornerRadius(30)
                }
            }
            .padding()
        }.modifier(Keyboard())
        .refreshable {
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
                        .background(Color(hex: viewModel.taskNameListColorCode(index:index)))
                    VStack(alignment: .leading){
                        
                        VStack(alignment: .leading){
                            TextEditorView(text: $viewModel.textFields[index].text, placeHolder: "Update Task...", index: index, viewModel: viewModel)
                        }.padding()
                    }.frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background(Color(hex: viewModel.taskListColorCode(index:index)))
                }
            }
            .background(Color(hex: "#E1D5D4"))
        }
    }
    
    @ViewBuilder var submitView: some View{
        ZStack {
            if viewModel.isShowUpdateSuccessTost {
                withAnimation(.easeInOut(duration: 0.3)) {
                    taskUpdateSuccessView.offset(y: self.viewModel.isShowUpdateSuccessTost ? 0 : UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.bottom)
                }
              
            }else{
                Button {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.viewModel.updateDate()
                    }
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
        }
        .padding(.bottom,10)
    }
   
    @ViewBuilder var taskUpdateSuccessView: some View {
        VStack {
            withAnimation(Animation.easeInOut(duration: 0.1)) {
                Image("success")
                    .resizable()
                    .frame(width: viewModel.width,height: viewModel.heigth)
            }
            Text("Update Successfully")
        }.padding()
    }
}

struct TextEditorView: View{
    @Binding var text: String
    var placeHolder:String?
    var index: Int
    var viewModel:SheetViewModel
    @FocusState private var isTextEditorFocus: Bool
    var body: some View {
        ZStack(alignment: .leading) {
           // FirstResponder(text: $text)
           TextEditor(text: $text)
                .focused($isTextEditorFocus)
                .background(Color(hex: viewModel.taskListColorCode(index:index)))
                .scrollContentBackground(.hidden)
            if text.isEmpty  {
                Text(placeHolder ?? "")
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .onTapGesture {
                        isTextEditorFocus = true
                    }
            }
        }.onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
    
}

struct FirstResponder: UIViewRepresentable {
    @Binding var text: String
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var becomeFirstResponder = false
        
       init(text: Binding<String>) {
           self._text = text
       }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becomeFirstResponder = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StatusTrackerView()
    }
}
