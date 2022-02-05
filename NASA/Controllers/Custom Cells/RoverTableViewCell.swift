//
//  RoverTableViewCell.swift
//  NASA
//
//  Created by adam smith on 2/4/22.
//

import UIKit

class RoverTableViewCell: UITableViewCell {

    @IBOutlet weak var roverCameraNameTextLabel: UILabel!
    @IBOutlet weak var roverImageview: UIImageView!
    
    var rover: Rover? {
        didSet {
            updateViews()
        }
    }
    
    
    private func updateViews() {
        guard let rover = rover else { return }
        self.roverCameraNameTextLabel.text = rover.cameraName
        
        RoverNetworkController.getImage(from: rover.imagePath) { image in
            DispatchQueue.main.async {
                self.roverImageview.image = image
            }
        }
    }
}
