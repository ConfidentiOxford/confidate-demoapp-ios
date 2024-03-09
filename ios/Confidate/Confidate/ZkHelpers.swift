import MoproKit

import Foundation

func readAndPrepareInputFromJSON(fileName: String) -> [String: [String]]? {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        print("Failed to load file from bundle.")
        return nil
    }

    do {
        // Parse the JSON data
        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            var preparedInputs = [String: [String]]()
            
            // Iterate through each key-value pair in the JSON object
            for (key, value) in jsonObject {
                // Convert the value to the required format
                let flattenedArray = flattenArray(value)
                preparedInputs[key] = flattenedArray
            }
            
            return preparedInputs
        }
    } catch {
        print("Failed to parse JSON with error: \(error)")
    }
    
    return nil
}

// Function to recursively flatten any nested arrays into a single-dimensional array of strings
func flattenArray(_ value: Any) -> [String] {
    var result = [String]()
    
    if let array = value as? [Any] {
        for item in array {
            result.append(contentsOf: flattenArray(item))
        }
    } else if let string = value as? String {
        result.append(string)
    } else if let number = value as? NSNumber {
        result.append(number.stringValue)
    }
    
    return result
}


func prove(inputs: [String: [String]], circuitName: String) -> (Data?, Data?)? {
    let moproCircom = MoproKit.MoproCircom()
    var generatedProof: Data?
    var publicInputs: Data?
    

    // Ensure your resource files are correctly named and placed in the app's bundle.
    guard let arkzkeyPath = Bundle.main.path(forResource: circuitName, ofType: "arkzkey"),
          let wasmPath = Bundle.main.path(forResource: circuitName, ofType: "wasm") else {
        print("Failed to locate resource files in bundle.")
        return nil
    }

    do {
        try moproCircom.initialize(arkzkeyPath: arkzkeyPath, wasmPath: wasmPath)
    } catch {
        print("Failed to initialize MoproKit with error: \(error)")
        return nil
    }

    do {
        let result = try moproCircom.generateProof(circuitInputs: inputs)
        generatedProof = result.proof
        publicInputs = result.inputs
    } catch {
        print("Failed to generate proof with error: \(error)")
        return nil
    }

    return (generatedProof, publicInputs)
}


func verify(proof: Data, publicInputs: Data, circuitName: String) -> Bool {
    let moproCircom = MoproKit.MoproCircom()

    // Ensure your resource files are correctly named and placed in the app's bundle.
    guard let arkzkeyPath = Bundle.main.path(forResource: circuitName, ofType: "arkzkey"),
          let wasmPath = Bundle.main.path(forResource: circuitName, ofType: "wasm") else {
        print("Failed to locate resource files in bundle.")
        return false
    }

    do {
        try moproCircom.initialize(arkzkeyPath: arkzkeyPath, wasmPath: wasmPath)
    } catch {
        print("Failed to initialize MoproKit with error: \(error)")
        return false
    }
    
    do {
        let isValid = try moproCircom.verifyProof(proof: proof, publicInput: publicInputs)
        return isValid
    } catch {
        print("Proof verification failed with error: \(error)")
        return false
    }
}
