//
//  ScratchView.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import SwiftUI

struct ScratchView: View {
    @EnvironmentObject var store: ScratchCardStore

    @State private var points: [CGPoint] = []

    private let gridSize = 5
    private let gridCellSize = 50
    private let scratchClearAmount: CGFloat = 0.75

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                SilverGrainBackground()
                    .frame(width: 300, height: 300)
                    .cornerRadius(20)
                    .overlay {
                        if store.canScratch {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(2)
                        }
                    }

                if store.canScratch {
                    RevealedCodeView(code: store.code)
                    // inspired by https://github.com/anupdsouza/ios-scratch-card-view
                        .mask(
                            Path { path in
                                path.addLines(points)
                            }.stroke(style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .round))
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged { value in
                                    points.append(value.location)
                                }
                                .onEnded { _ in
                                    let cgpath = Path { path in
                                        path.addLines(points)
                                    }.cgPath

                                    let thickenedPath = cgpath.copy(
                                        strokingWithWidth: 50,
                                        lineCap: .round,
                                        lineJoin: .round,
                                        miterLimit: 10
                                    )

                                    var scratchedCount = 0

                                    for i in 0..<gridSize {
                                        for j in 0..<gridSize {
                                            let point = CGPoint(x: gridCellSize / 2 + i * gridCellSize, y: gridCellSize / 2 + j * gridCellSize)
                                            if thickenedPath.contains(point) {
                                                scratchedCount += 1
                                            }
                                        }
                                    }

                                    let scratchedPercentage = Double(scratchedCount) / Double(gridSize * gridSize)

                                    if scratchedPercentage > scratchClearAmount {
                                        store.setScratched()
                                    }
                                }
                        )
                } else if store.isScratched {
                    RevealedCodeView(code: store.code)
                }
            }
            
            Spacer()
            
            Button(action: {
                store.setScratched()
            }) {
                HStack {
                    Image(systemName: "hand.tap")
                    Text("Scratch Card")
                }
                .roundedButton(color: !store.canScratch ? Color.gray : Color.blue)
            }
            .disabled(!store.canScratch)

            Spacer()
        }
        .padding()
        .navigationTitle("Scratch")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            Task {
                try await store.generateCode()
            }
        }
        .onDisappear {
            store.cancelCodeGeneration()
        }
    }
}

#Preview {
    NavigationView {
        ScratchView().environmentObject(ScratchCardStore(service: NetworkService(), exclusiveMin: "6.1"))
    }
}
