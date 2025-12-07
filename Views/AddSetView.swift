//
//  AddSetView.swift
//  Flashy Cards
//
//  Created by Joshua Chapman on 12/6/25.
//

import SwiftUI

struct AddSetView: View {
    @ObservedObject var vm: FlashcardSetViewModel
    @Environment(\.dismiss) var dismiss
    @State private var title = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Set Title", text: $title)
                Button("Save") {
                    vm.addSet(title: title)
                    dismiss()
                }
            }
            .navigationTitle("New Set")
        }
    }
}
