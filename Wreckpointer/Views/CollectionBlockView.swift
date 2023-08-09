//
//  CollectionBlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionBlockView: View {
    
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @Binding var collection: Collection
    @Binding var block: Block
    
    var body: some View {
        VStack {
            blockImage
                .contextMenu {
                    Button(role: .destructive) {
                        delete(block: block)
                    } label: {
                        Label("Delete block", systemImage: "trash.circle")
                    }
                }
                .padding(.top, 20)
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
        }
    }
    
    var blockImage: some View {
        ImageView(imageData: $block.image)
            .overlay(alignment: .bottom) {
                HStack {
                    Text("\(Int(block.number)).")
                    Text(block.title)
                    Spacer()
                    NavigationLink {
                        AddUpdateBlockView(originalCollection: $collection, block: block)
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .font(.headline)
                    }
                }
                .font(.title)
                .bold()
                .padding(.horizontal)
                .glassyFont(textColor: .white)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
//            .overlay(alignment: .top) {
//                NavigationLink {
//                    AddUpdateBlockView(originalCollection: $collection, block: block)
//                } label: {
//                    Label("Edit", systemImage: "pencil.circle")
//                        .foregroundColor(.yellow)
//                }
//                .font(.title)
//                .bold()
//                .padding(.horizontal)
//                .glassyFont(textColor: .white)
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .background(.ultraThinMaterial)
//            }
    }
    
    var blockDescription: some View {
        Text(block.description)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

struct CollectionBlockView_Previews: PreviewProvider {
    static var previews: some View {
        let collection = Collection(title: "Empty", description: "", blocks: [ ])
        let block = Block(id: "block1",
                          title: "Titanic",
                          number: 1,
                          wreckID: "123451245",
                          description: "Titanic was 882 feet 9 inches (269.06 m) long with a maximum breadth of 92 feet 6 inches (28.19 m). Her total height, measured from the base of the keel to the top of the bridge, was 104 feet (32 m). She measured 46,329 GRT and 21,831 NRT and with a draught of 34 feet 7 inches (10.54 m), she displaced 52,310 tons.",
                          image: nil,
                          createdAt: Date(),
                          updatedAt: Date())
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let collectionsService = CollectionsService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
 
        // Init View model
        let collectionsViewModel = CollectionsViewModel(collectionsService: collectionsService)
        
        CollectionBlockView(collection: .constant(collection), block: .constant(block))
            .environmentObject(collectionsViewModel)
    }
}


// MARK: - Functions

extension CollectionBlockView {
    func delete(block: Block) {
        Task {
            do {
                try await collectionsVM.removeBlock(block, fromCollection: collection)
                if let index = collection.blocks.firstIndex(where: { $0.id == block.id }) {
                    DispatchQueue.main.async {
                        collection.blocks.remove(at: index)
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
}
