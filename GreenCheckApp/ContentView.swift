//
//  ContentView.swift
//  GreenCheckApp
//
//  Created by Florian Bauer on 26.04.21.
//

import SwiftUI
import CoreData
import ValidationCore
import CodeScanner

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingSheet = false
    @State private var errorMessage = "h"

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    private func Kurz(item: Item) -> Text {
        return Text("\(String((item.givenName?.prefix(1))!))\(String((item.familyName?.prefix(1))!))")
    }
    
    func getEntityById(id: String) -> Item? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format: "certificate = %d", id)

        var results: [NSManagedObject] = []

        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results.first as? Item ?? Item(context: viewContext)
    }
    
    public func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        switch result {
            case .success(let code):
                let validationCore = ValidationCore()
                validationCore.validate(encodedData: code) { (data) in
                    
                    
                    switch data {
                    case .success(let payload):
                        let validationResult: ValidationResult = payload;
                        
                        if(validationResult.isValid) {
                            print(validationResult.payload.person)
                            self.addItem(code: code, payload: validationResult.payload)
                        } else {
                            print("Not Valid")
                        }
                    
                    case .failure(let error):
                        print("Scanning failed \(error)")
                        print(error)
                        self.showingSheet = true
                        self.errorMessage = error.rawValue
                    }
                }
            case .failure(let error):
                print("Scanning failed \(error)")
        }
    }
    
    var body: some View {
        VStack {
            Text("GreenCheckApp").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color.secondary)
            CodeScannerView(codeTypes: [.qr], scanMode: .oncePerCode,  simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan).background(Color.black.opacity(0.3))
            List {
                ForEach(items) { item in
                    HStack {
                        Kurz(item: item).foregroundColor(Color.white).frame(width: 32, height: 32).background(Color.green)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                
                        VStack(alignment: .leading) {
                            Text("\(item.dateOfBirth ?? "")")
                        .foregroundColor(.gray)
                            Text("\(item.givenName ?? "") \(item.familyName ?? "") ")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }.sheet(isPresented: $showingSheet) {
            VStack {
                Text("QRCode nicht gültig")
                if let item = errorMessage {
                    Text(item)
                  }
            }
        }
    }

    private func addItem(code: String, payload: EuHealthCert) {
        
        
        withAnimation {
            
            guard let newItem = self.getEntityById(id: code) else {
                return
            }
            
            newItem.isValid = true
            newItem.givenName = payload.person.givenName ?? ""
            newItem.standardizedGivenName = payload.person.standardizedGivenName ?? ""
            newItem.familyName = payload.person.familyName ?? ""
            newItem.standardizedFamilyName = payload.person.standardizedFamilyName
            newItem.dateOfBirth = payload.dateOfBirth
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
