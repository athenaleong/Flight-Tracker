//
//  AirportInfoTableViewCell.swift
//  LufthansaMP4Skeleton
//
//  Created by Athena and Matthew on 11/2/19.
//  Copyright © 2019 us. All rights reserved.
//

import UIKit

class AirportInfoTableViewCell: UITableViewCell {
    
    
    var flightName = "Placeholder text"
    var nameLabel: UILabel!
    var flight: Flight? 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func initCellFrom(size: CGSize) {
        nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: size.width, height: 20))
        nameLabel.textColor = .black
        nameLabel.text = flightName
        contentView.addSubview(nameLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
