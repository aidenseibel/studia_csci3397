//
//  SaveStudySetView.swift
//  studia_csci3397
//
//  Created by Khoi Tran on 4/30/25.
//
import Foundation
import SwiftUI

struct SaveStudySetView: View {
    let flashcards: [Flashcard]
    @State private var studySetName = ""
    @State private var studySetDescription = ""
    @State private var isSaving = false
    @State private var showSavedConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Name your study set")
                    .font(.headline)
                
                TextField("Study Set Name", text: $studySetName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Description (Optional)")
                    .font(.headline)
                
                TextField("Add a description", text: $studySetDescription)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Flashcards Preview")
                    .font(.headline)
                    .padding(.top)
                
                // Show preview of flashcards
                if !flashcards.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Generated Flashcards")
                            .font(.headline)
                        
                        ForEach(flashcards.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text("Card \(index + 1)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("Question: \(flashcards[index].question)")
                                    .padding(.vertical, 2)
                                
                                Text("Answer: \(flashcards[index].answer)")
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 2)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }

                    }
                }
                

                
                Button {
                    saveStudySet()
                } label: {
                    HStack {
                        Spacer()
                        Text("Save Study Set")
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(studySetName.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                }
                .disabled(studySetName.isEmpty || isSaving)
                .padding(.top)
            }
            .padding()
            .navigationTitle("Save Study Set")
            .alert(isPresented: $showSavedConfirmation) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your study set has been saved successfully!"),
                    dismissButton: .default(Text("OK")) {
                        // Navigate back to the root view
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    private func saveStudySet() {
        isSaving = true
        
        // Create the study set
        let newStudySet = Study_Set(
            name: studySetName,
            description: studySetDescription,
            Flashcards: flashcards
        )
        
        // Save it (simulate a small delay for UX)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            StudySetStorage.shared.saveStudySet(newStudySet)
            isSaving = false
            showSavedConfirmation = true
        }
    }
}
