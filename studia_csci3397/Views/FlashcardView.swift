//
//  FlashcardView.swift
//  studia_csci3397
//
//  Created by Khoi Tran on 4/4/25.
//

import SwiftUI

struct FlashcardView: View {
    let flashcard: Flashcard
    @Binding var isAnswer :Bool
    
    var body: some View{
        VStack{
            ZStack{
                cardFace(content: flashcard.question, isAnswer: false)
                    .opacity(isAnswer ? 0 : 1)
                    .rotation3DEffect(.degrees(isAnswer ? 180: 0), axis: (x:0, y:1, z:0))
                cardFace(content: flashcard.answer, isAnswer: true)
                    .opacity(isAnswer ? 1 : 0)
                    .rotation3DEffect(.degrees(isAnswer ? 0: -180), axis: (x:0, y:1, z:0))
            }
            .onTapGesture {
                withAnimation(.spring()){
                    isAnswer.toggle()
                }
            }
        }
    }
}

@ViewBuilder
private func cardFace(content: String, isAnswer: Bool) -> some View{
    let aqua = Color("aqua")

    RoundedRectangle(cornerRadius: 12)
        .fill(isAnswer ? aqua : Color.white)
        .frame(width: 320, height:240)
        .shadow(radius: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            
        )
        ScrollView{
            Text(content)
                .font(.system(size:18))
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
}
