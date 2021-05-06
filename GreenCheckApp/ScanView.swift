//
//  ScanView.swift
//  GreenCheckApp
//
//  Created by Florian Bauer on 03.05.21.
//

import SwiftUI
import CodeScanner
import ValidationCore
import AVFoundation

struct ScanView: View {
    
    @Binding var showingSheet:Bool
    @Binding var showDetail:Bool
    @Binding var statusSuccess:Bool
    @Binding var timeRemaining:Int
    @Binding var wiggle:Bool
    
    var handleScan: (_ result: Result<String, CodeScannerView.ScanError>) -> Void
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                    device.torchMode = .off
                } else {
                    device.torchMode = .on
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    var body: some View {
        ZStack {
            CodeScannerView(
                codeTypes: [.qr],
                scanMode: .continuous,
                scanInterval: 2,
                simulatedData: "<not ready yet>",
                completion: handleScan)
                    .background(Color.black.opacity(0.3))
                    .zIndex(0)
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.5))
                    .mask(Window(size: CGSize(width: UIScreen.main.bounds.width-44, height: UIScreen.main.bounds.width-44)).fill(style: FillStyle(eoFill: true)))
            }.zIndex(1)
            VStack {
                HStack {
                    Button(action: {
                        toggleTorch()
                    }) {
                        Image("brightness")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(10)
                            .padding(.top, 8)
                            .padding(.leading, 28)
                    }
                    Spacer()
                    Button(action: {
                        showingSheet.toggle()
                    }) {
                        Image("info").resizable()
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(10).padding(.top, 8).padding(.trailing, 28)
                    }
                }.frame(width: UIScreen.main.bounds.width, height: 94, alignment: .top)
                Image("scan window")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.width-40)
                    .padding(.top, 68)
                if !showDetail {
                    Text("Positioniere den QR-Code innerhalb des Rahmens")
                        .font(.custom("Author-Regular", size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
            }.zIndex(2)
            VStack {
                GeometryReader { geometry in
                        InfoView(
                            icon: statusSuccess ? "badge ok" : "badge nok",
                            isOpen: self.$showDetail,
                            maxHeight: 303,
                            color: statusSuccess ? Color.customGreen : Color.customRed,
                            wiggle: self.$wiggle
                        ) {
                            if statusSuccess {
                                Text("Passt.")
                                    .font(.custom("Author-Semibold", size: 72))
                                    .foregroundColor(.white)
                                    .padding(.top, 82)
                            }
                            if !statusSuccess {
                                    VStack{
                                        Text("Ojemine!")
                                            .font(.custom("Author-Semibold", size: 72))
                                            .foregroundColor(.white)
                                        Text("Das ist kein gültiger QR Code")
                                            .font(.custom("Author-Semibold", size: 24))
                                            .foregroundColor(.white)
                                    }.padding(.top, 77)
                            }
                        }
                    }
            }.zIndex(3)
            .onReceive(Timer.publish(every: 1, on: .current, in: .default).autoconnect()) { _ in
                    self.timeRemaining -= 1
                    if self.timeRemaining <= 0 {
                        self.showDetail = false
                    }
                }
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScanView(showingSheet: .constant(true), showDetail: .constant(true), statusSuccess: .constant(false), timeRemaining: .constant(2), wiggle: .constant(false)) { (result) in
                return
            }
            .previewDevice("iPhone 12 Pro Max")
            
            ScanView(showingSheet: .constant(true), showDetail: .constant(true), statusSuccess: .constant(false), timeRemaining: .constant(2), wiggle: .constant(false)) { (result) in
                return
            }
        }
    }
}
