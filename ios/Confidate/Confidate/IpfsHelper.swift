import Foundation

import Alamofire

func uploadFileToIPFSAlamofire(fileURL: URL, completion: @escaping (String?, Error?) -> Void) {
    let headers: HTTPHeaders = [
        "Authorization": "Basic \(credentials)"
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
                completion(nil, NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
            }
        case .failure(let error):
            completion(nil, error)
        }
    }
}
