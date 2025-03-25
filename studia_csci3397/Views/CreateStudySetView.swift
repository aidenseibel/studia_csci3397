//
//  CreateStudySsetView.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import SwiftUI
import UIKit

struct CreateStudySetView: View {
    @State var showImagePicker = false
    @State var image: UIImage? = nil
    @State var sourceType: UIImagePickerController.SourceType = .camera

    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth * 0.90, height: screenWidth * 1.10)
                        .clipped()
                } else {
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
                                
                if let image = image{
                    Button {
                        DataModel.sendImageToOpenAI(image: image){ (success, price) in
                            if success {
                                print("Success")
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Create study set")
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                    }
                }
                
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image, sourceType: $sourceType)
            }
            .navigationTitle("Create a new study set")
        }
    }
}

#Preview {
    CreateStudySetView()
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
