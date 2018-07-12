//
//  DataService.swift
//  MVVM Alamofire
//
//  Created by Arifin Firdaus on 7/12/18.
//  Copyright © 2018 Arifin Firdaus. All rights reserved.
//

import Foundation
import Alamofire

struct DataService {
    
    // MARK: - Singleton
    static let shared = DataService()
    
    // MARK: - URL
    private var photoUrl = "https://jsonplaceholder.typicode.com/photos"
    
    // MARK: - Services
    func requestFetchPhoto(with id: Int, completion: @escaping (Photo?, Error?) -> ()) {
        let url = "\(photoUrl)/\(id)"
        Alamofire.request(url).responsePhoto { response in
            if let error = response.error {
                completion(nil, error)
                return
            }
            if let photo = response.result.value {
                completion(photo, nil)
                return
            }
        }
    }
    
}
