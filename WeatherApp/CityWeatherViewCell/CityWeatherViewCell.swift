//
//  CityWeatherViewCell.swift
//  WeatherApp
//
//  Created by ilomidze on 24.02.21.
//

import UIKit

class CityWeatherViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var cityTemp: UILabel!
    
    @IBOutlet weak var cityWeatherImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
