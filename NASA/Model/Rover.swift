//
//  Rover.swift
//  NASA
//
//  Created by adam smith on 2/4/22.
//

import Foundation

class Rover {
    
    enum Keys: String {
        case camera = "camera"
        case cameraName = "full_name"
//        case earthDate = "earth_date"
        case imagePath = "img_src"
    }
    
    
    let cameraName: String
//    let earthDate: String
    let imagePath: String
    
    init?(dictionary: [String: Any]) {
//        guard let earthDate = dictionary[Keys.earthDate.rawValue] as? String,
            guard let imagePath = dictionary[Keys.imagePath.rawValue] as? String,
              let cameraDict = dictionary[Keys.camera.rawValue] as? [String: Any],
              let camerName = cameraDict[Keys.cameraName.rawValue] as? String
        else { return nil }
        
        self.cameraName = camerName
//        self.earthDate = earthDate
        self.imagePath = imagePath
    }
}

