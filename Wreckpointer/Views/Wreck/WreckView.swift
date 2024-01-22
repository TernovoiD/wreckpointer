//
//  WreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import SwiftUI

struct WreckView: View {
    
    @AppStorage("proSubscription", store: UserDefaults(suiteName: "group.MWQ8P93RWJ.com.danyloternovoi.Wreckpointer"))
    var proSubscription: Bool = false
    @StateObject var viewModel = WreckViewModel()
    @State var wreck: Wreck
    @State var loadWreck: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ImageView(imageData: $wreck.image, placehoder: "warship.sunk")
                        .scaledToFill()
                        .overlay { imageOverlay }
                    WreckInfoView(wreck: wreck)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding()
                    .padding(.top, 15)
                    Divider()
                        .padding(.bottom)
                    Text(wreck.history ?? "")
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                }
            }
            .navigationTitle("Overview")
            .task {
                if loadWreck {
                    let serverWreck = await viewModel.synchronize(wreck: wreck)
                    if let serverWreck {
                        updateView(with: serverWreck)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    if !wreck.isApproved {
                        NavigationLink("Edit") {
                            EditWreckView(wreckID: wreck.id)
                        }
                        .font(.headline.bold())
                    }
                }
        }
            if proSubscription == false {
                BannerContentView()
            }
        }
    }
    
    private func updateView(with wreck: Wreck) {
        withAnimation {
            self.wreck = wreck
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
        WreckView(wreck: Wreck.test, loadWreck: true)
            .environmentObject(WreckViewModel())
    }
}
