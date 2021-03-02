//
//  DetailedInfoController.swift
//  WeatherApp
//
//  Created by ilomidze on 24.02.21.
//

import UIKit

class DetailedInfoController: UIViewController {

    @IBOutlet weak var imgCond: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var city:String?
    var temp:Int?
    var cond:WeatherCond?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = city
        tempLabel.text = "\(String(temp ?? 0)) C"
        switch cond {
        case .cloud:
            imgCond.image = UIImage(named: "cloud")
        case .rain:
            imgCond.image = UIImage(named: "rain")
        default:
            imgCond.image = UIImage(named: "sun")
        }
    }
    
    
    //: Update Info Displayer
    func updateView(city:String, temperature temp:Int, condition cond:WeatherCond) {
        self.temp = temp
        self.city = city
        self.cond = cond
    }

}
