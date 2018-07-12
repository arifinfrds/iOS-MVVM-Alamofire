//
//  Photo.swift
//  MVVM Alamofire
//
//  Created by Arifin Firdaus on 7/12/18.
//  Copyright © 2018 Arifin Firdaus. All rights reserved.
//


// To parse the JSON, add this file to your project and do:
//
//   let photo = try Photo(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePhoto { response in
//     if let photo = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct Photo: Codable {
    let albumID: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailURL = "thumbnailUrl"
    }
}

// MARK: Convenience initializers
extension Photo {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Photo.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Alamofire response handlers
extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responsePhoto(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Photo>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
