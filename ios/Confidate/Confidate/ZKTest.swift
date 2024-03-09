//
//  ViewController.swift
//  MoproKit
//
//  Created by 1552237 on 09/16/2023.
//  Copyright (c) 2023 1552237. All rights reserved.
//

import MoproKit
import UIKit
import SwiftUI

struct ZKSetupView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ZKSetupViewController {
        return ZKSetupViewController()
    }
    
    func updateUIViewController(_ uiViewController: ZKSetupViewController, context: Context) {
    }
}

class ZKSetupViewController: UIViewController {

  let arkzkeyUrl = URL(string: "https://mopro.vivianjeng.xyz/keccak256_256_test_final.arkzkey")
  let wasmUrl = URL(string: "https://mopro.vivianjeng.xyz/keccak256_256_test.wasm")

  var setupButton = UIButton(type: .system)
  var proveButton = UIButton(type: .system)
  var verifyButton = UIButton(type: .system)
  var textView = UITextView()

  let moproCircom = MoproKit.MoproCircom()
  var generatedProof: Data?
  var publicInputs: Data?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set title
    let title = UILabel()
    title.text = "ZK (setup)"
    title.textColor = .white
    title.textAlignment = .center
    navigationItem.titleView = title
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true

    // view.backgroundColor = .white
    // navigationController?.navigationBar.prefersLargeTitles = true
    // navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    // navigationController?.navigationBar.barTintColor = UIColor.white // or any other contrasting color
    // self.title = "Keccak256 (setup)"

    setupUI()
  }

  func setupUI() {
    setupButton.setTitle("Setup", for: .normal)
    proveButton.setTitle("Prove", for: .normal)
    verifyButton.setTitle("Verify", for: .normal)

    textView.isEditable = false

    //self.title = "Keccak256 (setup)"
    //view.backgroundColor = .black

    // Setup actions for buttons
    setupButton.addTarget(self, action: #selector(runSetupAction), for: .touchUpInside)
    proveButton.addTarget(self, action: #selector(runProveAction), for: .touchUpInside)
    verifyButton.addTarget(self, action: #selector(runVerifyAction), for: .touchUpInside)

    setupButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    proveButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    verifyButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

    let stackView = UIStackView(arrangedSubviews: [
      setupButton, proveButton, verifyButton, textView,
    ])
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)

    // Make text view visible
    textView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
    ])
  }



    @objc func runSetupAction() {
        // Assuming 'mnist_ml.zkey' and 'witness.wtns' are the actual files you want to load,
        // but adjust the filenames according to your provided URLs or actual needs.
        guard let arkzkeyPath = Bundle.main.path(forResource: "placeholder", ofType: "arkzkey"),
              let wasmPath = Bundle.main.path(forResource: "placeholder", ofType: "wasm") else {
            print("Failed to locate resource files in bundle.")
            return
        }

        textView.text += "Loading files from app storage\n"
        
        // Record start time
        let start = CFAbsoluteTimeGetCurrent()

        do {
            try moproCircom.initialize(arkzkeyPath: arkzkeyPath, wasmPath: wasmPath)
            proveButton.isEnabled = true  // Enable the Prove button upon successful setup
            
            // Record end time and compute duration
            let end = CFAbsoluteTimeGetCurrent()
            let timeTaken = end - start
            
            textView.text += "Loading and initializing took \(timeTaken) seconds.\n"
        } catch let error as MoproError {
            textView.text += "MoproError: \(error)\n"
        } catch {
            textView.text += "Unexpected error: \(error)\n"
        }
    }


  @objc func runProveAction() {
    // Logic for prove
    guard proveButton.isEnabled else {
      print("Setup is not completed yet.")
      return
    }
    do {
      // Prepare inputs
      let inputVec: [UInt8] = [
        116, 101, 115, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
      ]
      let bits = bytesToBits(bytes: inputVec)
      var inputs = [String: [String]]()
      inputs["a"] = ["1", "0", "2", "4"]
      inputs["b"] = ["2"]

      // Multiplier example
      // var inputs = [String: [String]]()
      // let a = 3
      // let b = 5
      // inputs["a"] = [String(a)]
      // inputs["b"] = [String(b)]

      // Record start time
      let start = CFAbsoluteTimeGetCurrent()

      // Generate Proof
      let generateProofResult = try moproCircom.generateProof(circuitInputs: inputs)
      assert(!generateProofResult.proof.isEmpty, "Proof should not be empty")

      // Record end time and compute duration
      let end = CFAbsoluteTimeGetCurrent()
      let timeTaken = end - start

      // Store the generated proof and public inputs for later verification
      generatedProof = generateProofResult.proof
      publicInputs = generateProofResult.inputs
        
        // Safely unwrap the optional data
        if let data = publicInputs {
            // Ensure data contains bytes for 5 32-bit integers
            if data.count % MemoryLayout<Int32>.size == 0 {
                // Extract and print each number
                for i in stride(from: 0, to: data.count, by: MemoryLayout<Int32>.size) {
                    let range = i..<i+MemoryLayout<Int32>.size
                    let number = data.subdata(in: range).withUnsafeBytes { $0.load(as: Int32.self) }
                    print(number)
                }
            } else {
                print("Data does not contain a complete set of 32-bit integers")
            }
        } else {
            print("Data is nil")
        }

      textView.text += "Proof generation took \(timeTaken) seconds.\n"
      verifyButton.isEnabled = true  // Enable the Verify button once proof has been generated
    } catch let error as MoproError {
      print("MoproError: \(error)")
    } catch {
      print("Unexpected error: \(error)")
    }
  }

  @objc func runVerifyAction() {
    // Logic for verify
    guard let proof = generatedProof,
      let publicInputs = publicInputs
    else {
      print("Setup is not completed or proof has not been generated yet.")
      return
    }
    do {
      // Verify Proof
      let isValid = try moproCircom.verifyProof(proof: proof, publicInput: publicInputs)
      assert(isValid, "Proof verification should succeed")

      textView.text += "Proof verification succeeded.\n"
    } catch let error as MoproError {
      print("MoproError: \(error)")
    } catch {
      print("Unexpected error: \(error)")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

func bytesToBits(bytes: [UInt8]) -> [String] {
  var bits = [String]()
  for byte in bytes {
    for j in 0..<8 {
      let bit = (byte >> j) & 1
      bits.append(String(bit))
    }
  }
  return bits
}


#Preview {
    ZKSetupView()
}
