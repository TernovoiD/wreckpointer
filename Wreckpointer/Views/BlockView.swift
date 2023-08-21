//
//  BlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import SwiftUI

struct BlockView: View {
    
    let block: Block
    let wreck: Wreck?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("\(Int(block.number)).")
                Text(block.title)
                Spacer()
            }
            .font(.system(size: 30, weight: .heavy))
            .padding(.horizontal)
            if let wreck {
                MiniMapWreckView(wreck: wreck)
            }
            Text(block.description)
                .padding(.horizontal)
        }
        .padding(.leading, 6)
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: Block.test, wreck: Wreck.test)
            .environmentObject(AppData())
    }
}
