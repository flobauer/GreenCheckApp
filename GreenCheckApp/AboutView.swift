//
//  AboutView.swift
//  GreenCheckApp
//
//  Created by Florian Bauer on 03.05.21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.customGreen.edgesIgnoringSafeArea(.all)
            VStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.forestGreen)
                    .frame( width: 68, height: 3)
                    .padding(.top, 20)
                VStack (alignment: .leading) {
                    Text("Passt.")
                        .font(.custom("Author-Semibold", size: 36))
                        .padding(.bottom)
                        .foregroundColor(Color.forestGreen)
                    Text("Überprüfe zuverlässig, sicher und kostenlos, ob dein Gegenüber")
                        .font(.custom("Author-Medium", size: 21))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        .foregroundColor(Color.forestGreen)
                    HStack (alignment: .top) {
                        Image("Union")
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                        Text("gegen COVID-19 geimpft wurde,")
                            .font(.custom("Author-Medium", size: 21))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.forestGreen)
                        Spacer()
                    }
                    HStack (alignment: .top) {
                        Image("Union")
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                        Text("negativ auf Corona getestet wurde oder ")
                            .font(.custom("Author-Medium", size: 21))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.forestGreen)
                        Spacer()
                    }
                    HStack (alignment: .top) {
                        Image("Union")
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                        Text("eine COVID-19-Erkrankung durchgemacht hat.")
                            .font(.custom("Author-Medium", size: 21))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.forestGreen)
                        Spacer()
                    }.padding(.bottom, 10)
                    Text("Der QR-Check erfolgt offline und wir speichern keine persönlichen Daten.")
                        .font(.custom("Author-Medium", size: 21))
                        .foregroundColor(Color.forestGreen)
                }.padding(24).padding(.top, 36)
                Spacer()
                VStack {
                    Text("Eine Initiative mit ❤️ aus Wien von")
                        .font(.custom("Author-Regular", size: 16))
                        .foregroundColor(Color.forestGreen)
                    HStack {
                        Image("moonholding")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image("intuio")
                    }.padding(2)
                    Text("Version 1.72 © 2021")
                        .font(.custom("Author-Regular", size: 16))
                        .foregroundColor(Color.forestGreen)
                }.padding(.bottom, 36)
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
