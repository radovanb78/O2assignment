//
//  ActivationView.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import SwiftUI

struct ActivationView: View {
    @EnvironmentObject var store: ScratchCardStore

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 20) {
                if store.state == .activated {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }

                Text("Activate Card")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Code: \(store.code ?? "")")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .multilineTextAlignment(.center)

                Text("Tap the button below to activate your card")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button(action: {
                Task {
                    await store.activate()
                }
            }) {
                HStack {
                    if store.isActivating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "checkmark.circle")
                    }
                    Text(store.isActivating ? "Activating..." : "Activate Card")
                }
                .roundedButton(color: store.isActivating || store.state == .activated ? .gray : .green)
            }
            .disabled(store.isActivating || store.state == .activated)

            Spacer()
        }
        .padding()
        .navigationTitle("Activate")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ActivationView().environmentObject(ScratchCardStore(service: NetworkService(), exclusiveMin: "6.1"))
}
