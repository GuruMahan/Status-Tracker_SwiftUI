//
//  AlertView.swift
//  Status Tracker
//
//  Created by Guru Mahan on 18/03/23.
//

import SwiftUI

struct AlertView: View {
    @State var isSelected = false
    @State var isSelectedIndMem = false
    @Binding var isCanclePopUp:Bool
    @Binding var isShowSelectedMembers:Bool
    @State var presentPopup = false
    @Binding var isTextFieldEmptyErrorShow: Bool
    var viewModel: SheetViewModel
    
    var body: some View {
        ZStack{
            VStack{
                AlertView
            }
        }.frame(maxWidth: .infinity,maxHeight:.infinity)
            .background(Color.black.opacity(0.2))
    }
    
    @ViewBuilder var AlertView: some View {
        HStack {
            VStack(alignment: .center,spacing: 20){
                   Text("Send Alert Notification")
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.leading,2)
                HStack {
                    Image("forWardMessageIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.green)
                        .frame(width: 32,height: 32)
                       
                    Text("Post to the Channel")
                        .font(.body)
                }
                HStack(spacing: 60){
                    Button {
                        withAnimation(.easeIn(duration: 0.2)) {
                            isCanclePopUp = false
                        }
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.black.opacity(0.8))
                    }.padding(.trailing)
                    
                    
                    Button {
                        withAnimation(.easeIn(duration: 0.2)) {
                                isCanclePopUp = false
                            

                        }
                        var flag = true
                        for index in 0..<viewModel.textFields.count {
                            if viewModel.textFields[index].text.isEmpty {
                                flag = false
                                isTextFieldEmptyErrorShow = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                 isTextFieldEmptyErrorShow = false
                                }
                                
                            }
                        }
                        if flag {
                            viewModel.sendMessage()
                        }
                    } label: {
                        Text("Confirm")
                            .frame(width: 100,height: 40)
                            .foregroundColor(.white)
                            .background(Color(hex: "#300A60"))
                            .cornerRadius(10)
                    }.padding(.leading)
                    
                }
            }.frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
            Spacer()
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView( isCanclePopUp: .constant(false), isShowSelectedMembers: .constant(false), isTextFieldEmptyErrorShow: .constant(false), viewModel: SheetViewModel())
    }
}
