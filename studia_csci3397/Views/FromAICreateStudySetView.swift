//
//  FromAICreateStudySetView.swift
//  studia_csci3397
//
//  Created by Khoi Tran on 4/15/25.
//

import SwiftUI
import UIKit

struct FromAICreateStudySetView: View {
    @State var showImagePicker = false
    @State var image: UIImage? = nil
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @StateObject private var viewModel = FromAICreateFlashcardViewModel()
    
    @State private var studySetName = ""
    @State private var studySetDescription = ""
    @State private var navigateToStudySet = false
    @State private var createdStudySet: Study_Set?
    @Environment(\.dismiss) private var dismiss
    
    @State private var navigateToSaveStudySet = false
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
                    if let uiImage = image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenWidth * 0.90, height: screenWidth * 1.10)
                            .clipped()
                    } else {
                        PictureChoicesView(
                            sourceType: $sourceType,
                            showImagePicker: $showImagePicker
                        )
                    }
                    
                    if let image = image {
                        Button {
                            Task{
                                await viewModel.createFlashcardsFromImage(_image: image)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                if viewModel.isLoading{
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint:.white))
                                }
                                else {
                                    Text("Generate Flashcard")
                                }
                                Spacer()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                    }
                    
                    if !viewModel.Flashcards.isEmpty {
                        Button("Create Study Set") {
                            navigateToSaveStudySet = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $image, sourceType: $sourceType)
                }
                .navigationTitle("Create a new study set")
                .alert(isPresented: $viewModel.showErrorAlert){
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage),
                        dismissButton: .default(Text("OK")){
                            viewModel.showErrorAlert = false
                        }
                    )
                }
            }
        }
        .navigationDestination(isPresented: $navigateToSaveStudySet) {
            SaveStudySetView(flashcards: viewModel.Flashcards)
        }
    }
}

struct PictureChoicesView: View{
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var showImagePicker: Bool

    var body: some View{
        VStack(alignment: .leading) {
            Button(action: {
                sourceType = .camera
                showImagePicker = true
            }) {
                HStack(spacing: 20) {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 2){
                        Text("Open Camera")
                            .bold()
                        Text("Take a photo of your notes to create a study set")
                            .font(.system(size: 12))
                    }
                    Spacer()
                }
                .padding()
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
                
            }
            .buttonStyle(.plain)
            
            Button(action: {
                sourceType = .photoLibrary
                showImagePicker = true
            }) {
                HStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 2){
                        Text("Use photo library")
                            .bold()
                        Text("Upload a photo of your notes to create a study set")
                            .font(.system(size: 12))
                    }
                    Spacer()
                }
                .padding()
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    FromAICreateStudySetView()
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?

        init(image: Binding<UIImage?>) {
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}



