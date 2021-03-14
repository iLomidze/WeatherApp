//
//  DetailedInfoController.swift
//  WeatherApp
//
//  Created by ilomidze on 24.02.21.
//

import UIKit

class DetailedInfoController: UIViewController {

    @IBOutlet weak var imgCond: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var tempFeelLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    
    
    var city:String?
    var temp:Int?
    var cond:String?
    var tempFeel:Int?
    var windSpeed:Int?
    var pressure:Int?
    var longitude:Double?
    var latitude:Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempLabel.text = "\(String(temp ?? 0)) C"
        tempFeelLabel.text = "\(String(tempFeel ?? 0)) C"
        windSpeedLabel.text = "\(String(windSpeed ?? 0)) m/s"
        pressureLabel.text = "\(String(pressure ?? 1000)) Bar"
        lonLabel.text = "\(String(longitude ?? 0))"
        latLabel.text = "\(String(latitude ?? 0))"
        
        self.title = city
        
        switch cond {
        case "Clear":
            imgCond.image = UIImage(named: "sun")
        case "Moon":
            imgCond.image = UIImage(named: "moon")
        case "Clouds":
            imgCond.image = UIImage(named: "cloud")
        case "Rain":
            imgCond.image = UIImage(named: "rain")
        case "Thunderstorm":
            imgCond.image = UIImage(named: "thunderstorm")
        case "Snow":
            imgCond.image = UIImage(named: "snow")
        default:
            imgCond.image = UIImage(named: "mist")
        }

    }
    
    
    //: Update Info Displayer
    func updateView(city:String, temperature temp:Int, condition cond:String, tempFeel:Int, windSpeed:Int, pressure:Int, longitude:Double, latitude:Double) {
        self.temp = temp
        self.city = city
        self.cond = cond
        self.tempFeel = tempFeel
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.longitude = longitude
        self.latitude = latitude
    }

}
