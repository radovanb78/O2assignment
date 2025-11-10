//
//  ContentView.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = ScratchCardStore(service: NetworkService(), exclusiveMin: "6.1")

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Text("Scratch Card Status")
                        .font(.title2)
                        .fontWeight(.semibold)
                    StateDisplayView(state: store.state, code: store.code)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink(destination: ScratchView()) {
                        HStack {
                            Image(systemName: "hand.tap")
                            Text("Scratch Card")
                        }
                        .roundedButton(color: .blue)
                    }

                    NavigationLink(destination: ActivationView()) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Activate Card")
                        }
                        .roundedButton(color: !store.isScratched ? .gray : .green)
                    }
                    .disabled(!store.isScratched)
                }

                Spacer()
            }
            .padding()
        }
        .environmentObject(store)
        .alert(item: $store.globalError) { alert in
                    Alert(title: Text(alert.title),
                          message: Text(alert.message),
                          dismissButton: .default(Text("OK")))
                }
    }
}

#Preview {
    ContentView()
}
