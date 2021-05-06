//
//  InfoView.swift
//  GreenCheckApp
//
//  Created by Florian Bauer on 03.05.21.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 180
    static let indicatorWidth: CGFloat = 180
    static let snapRatio: CGFloat = 0.55
    static let minHeightRatio: CGFloat = 0
}

struct InfoView<Content: View>: View {
    @Binding var isOpen: Bool
    @Binding var wiggle: Bool
    
    @State var degrees: Double = 0
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    let icon: String
    let color: Color

    init(icon: String, isOpen: Binding<Bool>, maxHeight: CGFloat, color: Color, wiggle: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.icon = icon
        self.color = color
        self._wiggle = wiggle
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        Image(self.icon).resizable()
                .scaledToFit()
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
                ).rotation3DEffect(
                    .degrees(degrees),axis:(x: 0, y:1, z:0)
                )
            .onChange(of: wiggle, perform: { value in
                withAnimation  {
                    self.degrees += 360
                }
            })
    }

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding().zIndex(1)
                ZStack(alignment: .top) {
                    Rectangle()
                    .cornerRadius(12)
                    .foregroundColor(self.color.opacity(0.48))
                    self.content
                }.padding(.top, -120)
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.spring(), value: isOpen)
            .animation(.spring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(icon: "badge ok", isOpen: .constant(true), maxHeight: 600, color: Color.customGreen, wiggle: .constant(false)) {
            Text("Passt.").font(.custom("Author-Semibold", size: 72)).foregroundColor(.white)
                    .padding(.top, 82)
            }.edgesIgnoringSafeArea(.all)
        }
}
