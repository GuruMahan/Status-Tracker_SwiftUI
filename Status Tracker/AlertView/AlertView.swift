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
            VStack(alignment: .leading,spacing: 20){
                HStack{
                    Text("Send Alert Notification")
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.leading,2)
                }
                HStack{
                    Button {
                        isSelectedIndMem = false
                        isSelected = true
                    } label: {
                        Image(systemName: isSelected ? "circle.inset.filled" : "circlebadge")
                            .resizable()
                            .frame(width: 24,height: 24)
                            .foregroundColor( isSelected ?  Color(hex: "#300A60") : Color.black.opacity(0.6))
                    }
                    Text("Send to Channel")
                        .font(.body)
                }
                HStack{
                    Button {
                        isSelected = false
                        isSelectedIndMem = true
                    } label: {
                        Image(systemName: isSelectedIndMem ? "circle.inset.filled" : "circlebadge")
                            .resizable()
                            .frame(width: 24,height: 24)
                            .foregroundColor( isSelectedIndMem ?  Color(hex: "#300A60") : Color.black.opacity(0.6))
                    }
                    Text("Send to individual member")
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
                            if isSelectedIndMem{
                                isCanclePopUp = false
                                isShowSelectedMembers = true
                            }
                        }
                        
                    } label: {
                        Text("Confirm")
                            .frame(width: 100,height: 40)
                        // .padding()
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
        AlertView( isCanclePopUp: .constant(false), isShowSelectedMembers: .constant(false))
    }
}