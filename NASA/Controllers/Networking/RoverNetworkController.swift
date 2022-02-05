//
//  RoverNetworkController.swift
//  NASA
//
//  Created by adam smith on 2/4/22.
//

import Foundation
import UIKit.UIImage


class RoverNetworkController {
    
    enum baseURLString: String {
        
        case search = "https://api.nasa.gov"
        case image = "https://mars.nasa.gov"
    }
    
    static func fetchRover(from searchTerm: String, completion: @escaping ([Rover]?) -> Void) {
        
        guard let url = URL(string: baseURLString.search.rawValue) else {
            print("failed to get url from \(self.baseURLString)")
            completion(nil)
            return
        }
        
        var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/mars-photos/api/v1/rovers/curiosity/photos"
        
        let apiKey = URLQueryItem(name: "api_key", value: "TmUIdG3ycMAmGIpyAXy0Hv9PFslWVf6IexSjZcB5")
        
        let searchTerm = URLQueryItem(name: "earth_date", value: searchTerm)
        
        urlComponents?.queryItems = [searchTerm, apiKey]
        
        guard let finalURL = urlComponents?.url else {
            print("failed to get final URL from: \(urlComponents?.description)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else {
                print("unable to get data from: \(data)")
                completion(nil)
                return
            }
            
            do {
                
                guard let topLevelDict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
                      let photoArray = topLevelDict["photos"] as? [[String: Any]]
                else {
                          print("unable to deserialize data from: \(data)")
                          completion(nil)
                          return
                      }
                
                var roverHolder: [Rover] = []
                for rover in photoArray {
                    if let newRover = Rover(dictionary: rover) {
                        roverHolder.append(newRover)
                    } else {
                        print("failed to decode Rover: \(rover)")
                    }
                }
                
                completion(roverHolder)
            } catch let error {
                print(error)
                completion(nil)
            }
        }.resume()
    }
    
    static func getImage(from imagePath: String, completion: @escaping (UIImage?) -> Void) {
        guard let baseURL = URL(string: imagePath) else { completion(nil); return }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        urlComponents?.scheme = "https"
        
        guard let finalURL = urlComponents?.url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data,
                    let image = UIImage(data: data)
            else { completion(nil); return }
            
            completion(image)
            
        }.resume()
    }
    
}
