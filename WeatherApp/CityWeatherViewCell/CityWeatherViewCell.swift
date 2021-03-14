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
    
    func updateCell(city:String, Temperature temp:Int, Condition cond:String) -> Void {
        cityNameLabel.text = city
        cityTemp.text = String(temp)
    
        
        switch cond {
        case "Clear":
            cityWeatherImg.image = UIImage(named: "sun")
        case "Moon":
            cityWeatherImg.image = UIImage(named: "moon")
        case "Clouds":
            cityWeatherImg.image = UIImage(named: "cloud")
        case "Rain":
            cityWeatherImg.image = UIImage(named: "rain")
        case "Thunderstorm":
            cityWeatherImg.image = UIImage(named: "thunderstorm")
        case "Snow":
            cityWeatherImg.image = UIImage(named: "snow")
        default:
            cityWeatherImg.image = UIImage(named: "mist")
        }
    }
    
}
