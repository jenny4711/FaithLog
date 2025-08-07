//
//  QtView.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI

struct QtView: View {
    @State var openForm:Bool = false
    var body: some View {
        NavigationStack {
            ZStack{
                Color.colorBackground
                    .ignoresSafeArea()
                
                
                    .font(Font.heavy25)
                    .foregroundColor(Color.colorText)
                VStack{
                    VStack{
                        Image("logo")
                            .padding(.bottom,20)
                        Text("Qt List")
                            .font(Font.heavy25)
                        
                    }//:VSTACK(logo and title)
                    .padding(.vertical,20)
                    .foregroundColor(Color.colorText)
                    ScrollView{
                        ForEach(0..<5){ item in
                            NavigationLink{
                                QtDetail()
                            }label:{
                                QtListCellView()
                            }
                           
                        }
                        
                        
                    }
                    .padding(.horizontal,24)
                    HStack{
                        Spacer()
                        PlusBtnView(openForm: $openForm)
                    }
                    .padding(.trailing,24)
                }//:VSTACK(LIST)
                
                
            }//:ZSTACK
            .sheet(isPresented: $openForm) {
                QtFormView()
            }

        }//:NAVIGATIONSTACK
        

        
    }
}


 // MARK: - ListCell

struct QtListCellView: View {
    
    var body: some View {
        VStack{
            Text("창조 이전부터 존재하신 하나님아들")
                .font(Font.bold15)
               
            Text("요한복음 8:48-59")
                .font(Font.reg12)
        }
        .frame(maxWidth:.infinity)
        .padding()
        .background(Color.customText)
        .foregroundColor(Color.customBackground)
        .cornerRadius(15)
    }
}


 // MARK: - plus  button$$

struct PlusBtnView: View {
    @Binding var openForm:Bool
    var body: some View {
        Button(action: {
            openForm = true
        }) {
            ZStack{
                Circle()
                    .fill(Color.customText)
                    .frame(width:70)
                
                Image(systemName: "plus")
                    .font(Font.black30)
                    .foregroundColor(Color.customBackground)
                    
            }
        }
        
    }
}







#Preview {
    QtView()
}
