//
//  AvatarGeneration.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import Foundation

import OpenAIKit
import UIKit
import Foundation

class AvatarGenerator {

    let apiKey = ""
    let orgId = ""
    private let client: OpenAI
    
    init(){
        let configuration: Configuration = Configuration(
            organizationId: orgId,
            apiKey: apiKey
        )
        client = OpenAI(configuration)
    }

    func generate(userInfo: UserInfo) async -> UIImage? {
        let prompt = createAvatarPrompt(userInfo: userInfo)
        print("generating image for prompt: ", prompt)
        return await generateAvatarFromPrompt(prompt: prompt)
    }

    func generateAvatarFromPrompt(prompt: String) async -> UIImage? {
        let imageParam = ImageParameters(
            // A text description of the desired image(s).
            prompt: prompt,
            // The size of the generated images.
            resolution: .small,
            // The format in which the generated images are returned.
            responseFormat: .base64Json
        )
        do {
            let result = try await client.createImage(parameters: imageParam)
            let b64Image = result.data[0].image
            let image = try client.decodeBase64Image(b64Image)
            return image
        } catch {
            print("An error occurred: \(error)")
        }
        return nil
    }

    func createAvatarPrompt(userInfo: UserInfo) -> String {
        // create prompts array for efficient concatenation
        var prompts: [String] = []

        // create a base prompt
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
