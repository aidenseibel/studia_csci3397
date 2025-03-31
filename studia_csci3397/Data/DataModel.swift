//
//  DataModel.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import Foundation
import UIKit

class DataModel {
    static func sendImageToOpenAI(image: UIImage, completion: @escaping (Bool, Double) -> Void) {
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 512, height: 512))
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String else{
            print("API key not found")
            completion(false, 0.0)
            return
        }
        // encodes the image as base64 to be sent over the network
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.5)?.base64EncodedString() else {
            print("Failed to encode image")
            completion(false, 0.0)
            return
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonBody: [String: Any] = [ 
            "model": "gpt-4o", // Specify the model you want to use
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": "Create Flashcard for the following image" // prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpg;base64,\(imageData)" // image
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 4096

        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
        } catch {
            return
        }

        // make the actual http request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }

            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                } else {
                    print("Failed to convert data to string")
                }
            }
        }.resume()
    }
}
