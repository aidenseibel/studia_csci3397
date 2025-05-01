//
//  FromAICreateFlashcardViewModel.swift
//  studia_csci3397
//
//  Created by Khoi Tran on 4/15/25.
//

import Foundation
import SwiftUI

class FromAICreateFlashcardViewModel: ObservableObject{
    @Published var Flashcards : [Flashcard] = []
    @Published var isLoading : Bool = false
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    func createFlashcardsFromImage(_image: UIImage) async {
        print("START - createFlashcardsFromImage called")
        await MainActor.run{
            self.isLoading = true
        }
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String else{
            await MainActor.run{
                self.showError(message: "API key not found")
            }
            return
        }

        let resizedImage = resizeImage(image:_image, targetSize: CGSize(width: 512, height: 512))
        // encodes the image as base64 to be sent over the network
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.5)?.base64EncodedString() else {
            await MainActor.run{
                self.showError(message: "Failed to encode image")
            }
            return
        }
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            await MainActor.run{
                self.showError(message: "Invalid URL")
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "model": "gpt-4o", // Specify the model you want to use
            "messages": [
                [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": "Create flashcards from this image. Format each flashcard with **Front:** for the question and **Back:** for the answer. Separate each flashcard with ---"],
                        ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(imageData)"]]
                    ]
                ]
            ]
        ]
        // Check of request is sent of OPENAI
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            print("Request ready. Sending to OpenAI API ...")
            
        } catch {
            await MainActor.run{
                self.showError(message: "Failed to serialize request: \(error.localizedDescription)")
            }
            return
        }
        do {
            print("Sending Request...")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\nReceived response with status code: \(httpResponse.statusCode)")
                
                if !(200...299).contains(httpResponse.statusCode) {
                    await MainActor.run {
                        self.showError(message: "API Error with status code: \(httpResponse.statusCode)")
                    }
                    
                    return
                }
            }
            if let responseString = String(data: data, encoding: .utf8) {
                await MainActor.run {
                    print(responseString)
                    self.isLoading = false
                }
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ChatCompletionResponse.self, from: data)
                
                if let firstChoice = response.choices.first {
                    let content = firstChoice.message.content
                    
                    let parsedFlashcards = parseFlashcardsFromContent(content)
                    
                    await MainActor.run {
                        if parsedFlashcards.isEmpty {
                            self.showError(message: "No flashcards were found in the response")

                        } else {
                            print("\nSuccessfully parsed \(parsedFlashcards.count) flashcards")
                            self.Flashcards = parsedFlashcards
                            self.isLoading = false
                        }
                    }
                } else {
                    await MainActor.run {
                        self.showError(message: "No choices in response")

                    }
                }
            } catch {
                await MainActor.run {
                    self.showError(message: "Failed to decode response: \(error.localizedDescription)")
                }
            }
        } catch {
            await MainActor.run {
                self.showError(message: "Failed to fetch: \(error.localizedDescription)")
            }
        }
    }
    private func showError(message: String){
        self.errorMessage = message
        self.showErrorAlert = true
        self.isLoading = false
        print("ERROR: \(message)")
    }
    private func parseFlashcardsFromContent(_ content: String) -> [Flashcard] {
        var flashcards = [Flashcard]()
        
        // Split the content by the flashcard separator
        let sections = content.components(separatedBy: "---")
        
        for section in sections {
            let trimmedSection = section.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedSection.isEmpty { continue }
            
            // Find the question and answer parts
            let frontPattern = "**Front:"
            let backPattern = "**Back:"
            
            if let frontRange = trimmedSection.range(of: frontPattern),
               let backRange = trimmedSection.range(of: backPattern) {
                
                let frontStartIndex = trimmedSection.index(frontRange.upperBound, offsetBy: 0)
                let frontEndIndex = backRange.lowerBound
                
                let backStartIndex = trimmedSection.index(backRange.upperBound, offsetBy: 0)
                let backEndIndex = trimmedSection.endIndex
                
                var question = String(trimmedSection[frontStartIndex..<frontEndIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
                var answer = String(trimmedSection[backStartIndex..<backEndIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Clean up any remaining markdown
                question = question.replacingOccurrences(of: "**", with: "")
                answer = answer.replacingOccurrences(of: "**", with: "")
                
                let flashcard = Flashcard(question: question, answer: answer)
                flashcards.append(flashcard)
            }
        }
        
        return flashcards
    }
}
