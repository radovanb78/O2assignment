//
//  StateDisplayView.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import SwiftUI

struct StateDisplayView: View {
    let state: ScratchCardState
    let code: String?

    var body: some View {
        VStack(spacing: 16) {
            switch state {
                case .unscratched:
                Image(systemName: "rectangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                Text("Unscratched")
                    .font(.headline)
                    .foregroundColor(.gray)

            case .scratched:
                Image(systemName: "rectangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                Text("Scratched")
                    .font(.headline)
                    .foregroundColor(.orange)
                Text("Code: \(code ?? "")")
                    .font(.caption)
                    .foregroundColor(.secondary)

            case .activated:
                Image(systemName: "checkmark.rectangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                Text("Activated")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("Code: \(code ?? "")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    StateDisplayView(state: .activated, code: "12345")
}


