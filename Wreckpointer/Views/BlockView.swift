//
//  BlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import SwiftUI

struct BlockView: View {
    
    @Binding var block: Block
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("\(Int(block.number)).")
                Text(block.title)
                Spacer()
            }
            .font(.system(size: 30, weight: .heavy))
            .padding(.horizontal)
            MiniMapWreckView(wreckID: $block.wreckID)
            Text(block.description)
                .padding(.horizontal)
        }
        .padding(.leading, 6)
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: .constant(Block.test))
            .environmentObject(AppData())
    }
}
