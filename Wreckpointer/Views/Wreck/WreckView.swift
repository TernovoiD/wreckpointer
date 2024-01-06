//
//  WreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import SwiftUI

struct WreckView: View {
    
    @StateObject var viewModel = WreckViewModel()
    @State var wreck: Wreck
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ImageView(imageData: $wreck.image, placehoder: "warship.sunk")
                    .frame(height: 350)
                    .clipped()
                    .overlay { imageOverlay }
                Divider()
                    .padding(.top, 30)
                VStack(alignment: .leading, spacing: 0) {
                    if wreck.hasDisplacement.isValid {
                        Text("Displacement:  \(String(wreck.hasDisplacement.tons)) tons")
                    }
                    Text("Type:  \(wreck.hasType.description)")
                    Text("Cause:  \(wreck.hasCause.description)")
                    if wreck.hasDepth.isValid {
                        Text("Depth:  \(wreck.hasDepth.ft) ft.")
                    }
                    if wreck.hasDateOfLoss.isValid {
                        Text("Date of loss:  \(wreck.hasDateOfLoss.date.formatted(date: .abbreviated, time: .omitted))")
                    }
                    if wreck.hasLossOfLife.isValid {
                        Text("Loss of Life:  \(wreck.hasLossOfLife.souls) lives")
                    }
                    if wreck.isWreckDive {
                        Text("Open for wreck dive")
                    }
                }
                .font(.callout)
                .foregroundStyle(.primary)
                .padding()
                Divider()
                    .padding(.bottom)
                Text(wreck.history ?? "")
                    .font(.callout)
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.update(wreck: wreck)
            Task {
                await viewModel.synchronizeWithServer()
            }
        })
        .toolbar {
            ToolbarItem {
                
            }
        }
    }
    
    private func loadWreck() {
        Task {
//            let serverWreck = await server.loadWreck(wreck)
//            if let serverWreck {
//                wreck = serverWreck
//            }
        }
    }
    
    private var imageOverlay: some View {
        VStack {
            Spacer()
            HStack {
                if wreck.isApproved {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.green)
                }
                Text(wreck.hasName)
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .font(.title.weight(.black))
            .offset(y: 15)
            .shadow(color: .black, radius:5)
            .padding(.leading,5)
        }
    }
}

#Preview {
    NavigationView {
        WreckView(wreck: Wreck.test)
            .environmentObject(WreckViewModel())
    }
}
