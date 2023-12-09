//
//  AddWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 08.12.2023.
//

import SwiftUI

struct AddWreckView: View {
    
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
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Text("Add Wreck")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .mask(RoundedRectangle(cornerRadius: 15))
                .disabled(true)
        })
    }
}

#Preview {
    AddWreckView()
        .padding()
}
