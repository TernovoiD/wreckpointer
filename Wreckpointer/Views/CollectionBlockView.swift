//
//  CollectionBlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionBlockView: View {
    
    let block: Block
    
    var body: some View {
        VStack {
            blockImage
                .padding(.top, 50)
            blockDescription
            if let _ = block.wreckID {
                HStack(alignment: .center) {
                    Image(systemName: "mappin.square.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxHeight: 30)
                    Text("Show \(block.title) on map")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(0.5, contentMode: .fit)
                        .frame(maxHeight: 30)
                        .foregroundColor(.accentColor)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .frame(maxHeight: 60)
                .background(Color.gray.opacity(0.3))
            }
            Divider()
        }
    }
    
    var blockImage: some View {
        Image("battleship.logo")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 450)
            .overlay(alignment: .bottom) {
                HStack {
                    if let number = block.number {
                        Text("\(Int(number)).")
                    }
                    Text(block.title)
                    Spacer()
                }
                .font(.title)
                .bold()
                .padding(.horizontal)
                .glassyFont(textColor: .white)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
    }
    
    var blockDescription: some View {
        Text(block.description ?? "No information")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

struct CollectionBlockView_Previews: PreviewProvider {
    static var previews: some View {
        let block = Block(id: "block1",
                          title: "Titanic",
                          number: 1,
                          wreckID: "123451245",
                          description: "Titanic was 882 feet 9 inches (269.06 m) long with a maximum breadth of 92 feet 6 inches (28.19 m). Her total height, measured from the base of the keel to the top of the bridge, was 104 feet (32 m). She measured 46,329 GRT and 21,831 NRT and with a draught of 34 feet 7 inches (10.54 m), she displaced 52,310 tons.",
                          image: nil,
                          createdAt: Date(),
                          updatedAt: Date())
        CollectionBlockView(block: block)
    }
}
