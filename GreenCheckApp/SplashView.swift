//
//  SplashView.swift
//  GreenCheckApp
//
//  Created by Florian Bauer on 06.05.21.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.customGreen
            VStack {
                Image("splash")
                Text("Passt.").font(.custom("Author-Semibold", size: 72)).foregroundColor(Color.forestGreen).padding(.bottom, 16)
                Text("Checkt jeden").font(.custom("Author-Medium", size: 32)).foregroundColor(Color.forestGreen)
                Text("digitalen COVID-19").font(.custom("Author-Medium", size: 32)).foregroundColor(Color.forestGreen)
                Text("Impf- und Testnachweis").font(.custom("Author-Medium", size: 32)).foregroundColor(Color.forestGreen).padding(.bottom, 36)
                Image("austria").resizable().scaledToFit().frame(width: 60, height: 38, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Grüner Pass").font(.custom("Author-Semibold", size: 21)).foregroundColor(Color.forestGreen)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
