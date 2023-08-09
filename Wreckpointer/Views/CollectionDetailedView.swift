//
//  CollectionDetailedView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionDetailedView: View {
    
    @State var collection: Collection
    let emptyBlock = Block(title: "", number: 1, description: "")
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            collectionImage
            collectionTitle
            Text(collection.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            ForEach($collection.blocks) { $block in
                CollectionBlockView(collection: $collection, block: $block)
            }
            NavigationLink {
                AddUpdateBlockView(originalCollection: $collection, block: emptyBlock)
            } label: {
                Label("Add block", systemImage: "plus")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.accentColor)
                    .background(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke())
            }
        }
        .onAppear { sortBlocks() }
        .toolbar(content: {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink("Update") {
                    AddUpdateCollection(originalCollection: $collection, collection: collection)
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var collectionImage: some View {
        ImageView(imageData: $collection.image)
            .frame(maxHeight: 450)
            .background(Color.gray.opacity(0.4))
    }
    
    var collectionTitle: some View {
        HStack {
            Text(collection.title)
                .font(.title)
                .bold()
                .glassyFont(textColor: .accentColor)
            Spacer()
            Button {
                
            } label: {
                Label("Report", systemImage: "flag.fill")
                .padding()
                .font(.headline)
                .background(Color.gray.opacity(0.33))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
        .padding()
    }
}

struct CollectionDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        
        let titanic = Block(id: "block1",
                          title: "Titanic",
                          number: 1,
                          wreckID: "123451245",
                          description: "Titanic was 882 feet 9 inches (269.06 m) long with a maximum breadth of 92 feet 6 inches (28.19 m). Her total height, measured from the base of the keel to the top of the bridge, was 104 feet (32 m). She measured 46,329 GRT and 21,831 NRT and with a draught of 34 feet 7 inches (10.54 m), she displaced 52,310 tons.",
                          image: nil,
                          createdAt: Date(),
                          updatedAt: Date())
        
        let collection: Collection = Collection(id: UUID(uuidString: "collection1"),
                                                title: "Aircraft carriers",
                                                description: "An ocean liner is a type of passenger ship primarily used for transportation across seas or oceans. Ocean liners may also carry cargo or mail, and may sometimes be used for other purposes (such as for pleasure cruises or as hospital ships).[1] Only one ocean liner remains in service today.The category does not include ferries or other vessels engaged in short-sea trading, nor dedicated cruise ships where the voyage itself, and not transportation, is the primary purpose of the trip. Nor does it include tramp steamers, even those equipped to handle limited numbers of passengers. Some shipping companies refer to themselves as and their container ships, which often operate over set routes according to established schedules, as .Though ocean liners share certain similarities with cruise ships, they must be able to travel between continents from point A to point B on a fixed schedule, so must be faster and built to withstand the rough seas and adverse conditions encountered on long voyages across the open ocean.[2] To protect against large waves they usually have a higher hull and promenade deck with higher positioning of lifeboats (the height above water called the freeboard), as well as a longer bow than a cruise ship.[2] Additionally, for additional strength they are often designed with thicker hull plating than is found on cruise ships, as well as a deeper draft for greater stability, and have large capacities for fuel, food, and other consumables on long voyages.[2] On an ocean liner, the captain's tower (bridge) is usually positioned on the upper deck for increased visibility.[2]The first ocean liners were built in the mid-19th century. Technological innovations such as the steam engine, Diesel engine and steel hull allowed larger and faster liners to be built, giving rise to a competition between world powers of the time, especially between the United Kingdom, the German Empire, and to a lesser extent France. Once the dominant form of travel between continents, ocean liners were rendered largely obsolete by the emergence of long-distance aircraft after World War II. Advances in automobile and railway technology also played a role. After Queen Elizabeth 2 was retired in 2008, the only ship still in service as an ocean liner is RMS Queen Mary 2.",
                                                image: nil,
                                                createdAt: Date(),
                                                updatedAt: Date(),
                                                blocks: [titanic],
                                                approved: true)
        
        CollectionDetailedView(collection: collection)
    }
}


// MARK: - Functions

extension CollectionDetailedView {
    
    func sortBlocks() {
        collection.blocks.sort(by: { $0.number < $1.number })
    }
}
