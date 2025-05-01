//
//  StudySetSubView.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//
import Foundation
import SwiftUI

struct StudySetSubView: View {
    
    var study_set: Study_Set
    var onDelete: () -> Void
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(study_set.name)")
                    .font(.title2)
                Text("\(study_set.description)")
                Text("\(study_set.Flashcards.count) flashcards")
            }
            .padding(10)
            
            Spacer()
            
            // Add the trash button
            Button(action: {
                showDeleteConfirmation = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Study Set"),
                message: Text("Are you sure you want to delete '\(study_set.name)'? This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    onDelete()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

