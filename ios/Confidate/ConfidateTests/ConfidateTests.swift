import XCTest
@testable import Confidate // Import your project's module here

class MoproKitTests: XCTestCase {

    func testEndToEnd() {
        let fileName = "placeholder_input" // Name of your JSON input file without the extension
        let circuitName = "placeholder" // Base name for your .arkzkey and .wasm files

        // Read and prepare inputs from JSON
        guard let inputs = readAndPrepareInputFromJSON(fileName: fileName) else {
            XCTFail("Failed to read inputs from JSON")
            return
        }

        // Generate proof
        guard let result = prove(inputs: inputs, circuitName: circuitName) else {
            XCTFail("Failed to generate proof")
            return
        }
        
        // Attempt to unwrap the optional components of the tuple
        guard let proof = result.0, let pubInputs = result.1 else {
            XCTFail("Proof or public inputs are nil")
            return
        }

        // Verify proof
        let isValid = verify(proof: proof, publicInputs: pubInputs, circuitName: circuitName)
        XCTAssertTrue(isValid, "Proof should be valid")
    }
}
