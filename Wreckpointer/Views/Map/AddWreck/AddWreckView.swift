//
//  AddWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 08.12.2023.
//

import SwiftUI

struct AddWreckView: View {
    
    @EnvironmentObject var wreckpointerData: WreckpointerData
    @State private var tabSelection = 0
    
    //Required fileds
    @State var name: String = ""
    //Latitude
    @State var latitudeDegrees: String = ""
    @State var latitudeMinutes: String = ""
    @State var latitudeSeconds: String = ""
    @State var latitudeNorth: Bool = true
    //Longitude
    @State var longitudeDegrees: String = ""
    @State var longitudeMinutes: String = ""
    @State var longitudeSeconds: String = ""
    @State var longitudeEast: Bool = true
    
    // Optional fields
    @State var type: WreckTypes = .unknown
    @State var cause: WreckCauses = .unknown
    @State var isWreckDive: Bool = false
    @State var dateOfLoss: Date = Date()
    
    @State var depth: String = ""
    @State var deadweight: String = ""
    @State var lossOfLife: String = ""
    @State var description: String = ""
    @State var imageData: Data?
    
    init(wreck: Wreck) {
        self.name = wreck.name
        self.latitudeDegrees = latitudeDegrees
        self.latitudeMinutes = latitudeMinutes
        self.latitudeSeconds = latitudeSeconds
        self.latitudeNorth = latitudeNorth
        self.longitudeDegrees = longitudeDegrees
        self.longitudeMinutes = longitudeMinutes
        self.longitudeSeconds = longitudeSeconds
        self.longitudeEast = longitudeEast
        self.type = type
        self.cause = cause
        self.isWreckDive = isWreckDive
        self.dateOfLoss = dateOfLoss
        self.depth = depth
        self.deadweight = deadweight
        self.lossOfLife = lossOfLife
        self.description = description
        self.imageData = imageData
    }
    
    var body: some View {
        VStack(spacing: 5) {
            TabView(selection: $tabSelection.animation()) {
                WreckRequiredFieldsPlate(name: $name, latitudeDegrees: $latitudeDegrees, latitudeMinutes: $latitudeMinutes, latitudeSeconds: $latitudeSeconds, latitudeNorth: $latitudeNorth, longitudeDegrees: $longitudeDegrees, longitudeMinutes: $longitudeMinutes, longitudeSeconds: $longitudeSeconds, longitudeEast: $longitudeEast)
                    .tag(0)
                WreckSelectorsPlate(type: $type, cause: $cause, isWreckDive: $isWreckDive, dateOfLoss: $dateOfLoss)
                    .tag(1)
                WreckImagePlate(imageData: $imageData)
                    .tag(2)
                WreckDesctiptionPlate(description: $description)
                    .tag(3)
                WreckAdditionalInfoPlate(depth: $depth, deadweight: $deadweight, lossOfLife: $lossOfLife)
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxHeight: 180)
            .coloredBorder(color: .gray)
            
            HStack(spacing: 5) {
                ForEach(0..<5) { i in
                    Image(systemName: "circle.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(tabSelection == i ? Color.accentColor : Color.gray)
                }
            }
            saveButton
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            Task {
                await addWreck()
            }
        }, label: {
            Text("Save")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .mask(RoundedRectangle(cornerRadius: 15))
                .disabled(name.isEmpty || latitudeDegrees.isEmpty || longitudeDegrees.isEmpty ? true : false)
        })
    }
    
    private func addWreck() async {
//        guard let latitude = Double(latitudeDegrees + "." + latitudeMinutes + latitudeSeconds) else { return }
//        guard let longitude = Double(longitudeDegrees + "." + longitudeMinutes + longitudeSeconds) else { return }
//        let newWreck = Wreck(name: name,
//                             latitude: latitudeNorth ? latitude : -(latitude),
//                             longitude: longitudeEast ? longitude : -(longitude),
//                             type: type.rawValue, cause: cause.rawValue, depth: Double(depth), isWreckDive: isWreckDive, deadweight: Int(deadweight), dateOfLoss: dateOfLoss, lossOfLife: Int(lossOfLife), description: description, imageData: imageData)
//        await wreckpointerData.add(wreck: newWreck)
    }
}

#Preview {
    AddWreckView(wreck: Wreck.test)
        .environmentObject(WreckpointerData())
        .padding()
}
