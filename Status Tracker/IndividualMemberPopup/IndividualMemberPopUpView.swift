//
//  IndividualMemberPopUpView.swift
//  Status Tracker
//
//  Created by Guru Mahan on 18/03/23.
//

import SwiftUI

struct IndividualMemberPopUpView: View {
    @StateObject var viewModel:SheetViewModel
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                hearderView
                    .cornerRadius(15, corners: [.topLeft,.topRight])
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder var hearderView: some View{
        VStack{
            HStack{
                Text("Select Member")
                    .padding(.leading)
                Spacer()
                Image("Vector")
                    .padding(.trailing)
            }.padding()
            VStack{
                Image("Line 1")
                    .resizable()
                    .frame(height: 2)
            }.padding(.trailing,5)
                .padding(.leading,5)
            dataListView()
            
            Spacer()
            confirmButtonView
        }
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .background(Color.white)
    }
    
    @ViewBuilder func dataListView() ->  some View {
        VStack(alignment: .leading,spacing: 15){
            ForEach(0..<(viewModel.textFields.count ),id: \.self){ index in
                HStack(spacing: 10){
                    Image("Rectangle 7")
                    Text("\(viewModel.textFields[index].name ?? "")")
                    Spacer()
                }
            }
            
        }.padding()
    }
    
    @ViewBuilder var confirmButtonView: some View{
        VStack{
            Button {
                
            } label: {
                Text("Confirm")
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
}

struct IndividualMemberPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        IndividualMemberPopUpView(viewModel: SheetViewModel())
    }
}
