import Foundation

import Alamofire

func uploadFileToIPFS(fileURL: URL, completion: @escaping (String?, Error?) -> Void) {
    
    
    // WARNING! TODO - FILL IN THE REAL VALUES
    let projectId = "TODO - FILL IN WITH REAL VALUES"
    let projectSecret = "TODO - FILL IN WITH REAL VALUES"
    
    // Encode the credentials for HTTP Basic Authentication
    let credentialData = "\(projectId):\(projectSecret)".data(using: .utf8)
    guard let credentialBase64 = credentialData?.base64EncodedString() else {
        completion(nil, NSError(domain: "IPFSError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode credentials."]))
        return
    }
    let headers: HTTPHeaders = [
        "Authorization": "Basic \(credentialBase64)"
    ]
    
    let endpoint = "https://ipfs.infura.io:5001/api/v0/add"
    
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(fileURL, withName: "file", fileName: fileURL.lastPathComponent, mimeType: "image/png")
    }, to: endpoint, method: .post, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let value):
            if let json = value as? [String: Any], let hash = json["Hash"] as? String {
                completion(hash, nil)
            } else {
                completion(nil, NSError(domain: "IPFSError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
            }
        case .failure(let error):
            completion(nil, error)
        }
    }
}
