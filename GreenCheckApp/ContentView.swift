//
//  ContentView.swift
//  GreenCheckApp
//
//  Created by Florian Bauer on 26.04.21.
//

import SwiftUI
import CoreData
import CodeScanner
import ValidationCore

struct ContentView: View {
    @State var showingSheet = false
    
    @State private var statusSuccess: Bool = false
    @State private var showDetail: Bool = false
    @State private var timeRemaining:Int = 11
    @State private var wiggle:Bool = false
    
    private var validationCore = ValidationCore()
    
    public func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        
        // re/set time remaining
        self.timeRemaining = 7
        
        // an info box is already open, wiggle!
        if showDetail {
            self.wiggle.toggle()
        }
        
        // depending on the result show the screen
        switch result {
            case .success(let code):
                self.validationCore.validate(encodedData: code) { (data) in
                    switch data {
                    case .success(let payload):
                        let validationResult: ValidationResult = payload;
                        if(validationResult.isValid) {
                            print(validationResult.payload.person)
                            self.showDetail = true
                            self.statusSuccess = true
                        } else {
                            self.showDetail = true
                            self.statusSuccess = false
                        }
                    case .failure(let error):
                        print(error)
                        self.showDetail = true
                        self.statusSuccess = false
                    }
                }
            case .failure(let error):
                print("Scanning failed \(error)")
        }
    }
    
    var body: some View {
        ZStack {
            ScanView(
                showingSheet: $showingSheet,
                showDetail: $showDetail,
                statusSuccess: $statusSuccess,
                timeRemaining: $timeRemaining,
                wiggle: $wiggle,
                handleScan: handleScan
            )
            if timeRemaining > 7 {
                SplashView().transition(.opacity)
            }
        }.animation(.easeIn(duration: 0.2))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .statusBar(hidden: true)
        .sheet(isPresented: $showingSheet) {
            AboutView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 12")
    }
}

extension Color {
    static let customGreen = Color("customGreen")
    static let customRed = Color("customRed")
    static let forestGreen = Color("forestGreen")
}

struct Window: Shape {
    let size: CGSize
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)

        let origin = CGPoint(x: rect.midX - size.width / 2, y: 172)
        let clipPath = UIBezierPath(roundedRect: CGRect(origin: origin, size: size), cornerRadius: 20).cgPath
        path.addPath(Path(clipPath))
        return path
    }
}
