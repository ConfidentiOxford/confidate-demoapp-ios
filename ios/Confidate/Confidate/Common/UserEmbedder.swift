//
//  UserEmbedder.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//
import CoreML
import Foundation

class UserEmbedder {
    
    private let model: BERTEmbedder
    private let tokenizer: BertTokenizer
    
    init(){
        model = BERTEmbedder()
        tokenizer = BertTokenizer(maxLen: 256)
    }
    
    func embed(userInfo: UserInfo) throws -> MLMultiArray? {
        let prompt = createEmbeddingPrompt(userInfo: userInfo)
        print("generating embedding with prompt: ", prompt)
        // token ids array
        let tokenIdsArray: [Int] = tokenizer.tokenizeToIds(text: prompt)
        do {
            let tokenIds = try MLMultiArray(shape: [1, NSNumber(value: tokenIdsArray.count)], dataType: .double)
            for (index, id) in tokenIdsArray.enumerated() {
                tokenIds[index] = NSNumber(value: id)
            }
            // Continue using 'tokenIds' here
            let modelInput = BERTEmbedderInput(input_ids: tokenIds)
            // Now you can use modelInput with your BERTEmbedder model
            let prediction = try? model.prediction(input: modelInput).var_559
            return prediction
        } catch {
           throw error
        }
    }
    
    func createEmbeddingPrompt(userInfo: UserInfo) -> String {
        // create prompts array for efficient concatenation
        var prompts: [String] = []
        
        // create and append prompts
        let basePrompt: String = "The user is a"
        prompts.append(basePrompt)
        let genderPrompt: String = userInfo.gender
        prompts.append(genderPrompt)
        let agePrompt: String = "and his favorite animal is \(userInfo.animal)."
        prompts.append(agePrompt)
        let hobbiePrompt: String = "The users hobbie is \(userInfo.hobbie)."
        prompts.append(hobbiePrompt)
        // concat prompts into one prompt
        return prompts.joined(separator: " ")
    }
}
