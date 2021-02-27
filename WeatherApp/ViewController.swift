//
//  ViewController.swift
//  WeatherApp
//
//  Created by ilomidze on 24.02.21.
//

import UIKit

class ViewController: UIViewController {

//: - var weatherData = [Weather]()
    var weatherData = [
        "s",
        "ss",
        "sss"
    ]
    
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityTable.delegate = self
        cityTable.dataSource = self
        
        // aqedan ar mushaobs, da ratom? - exla main storyboard-is inspectoridanaa gacentrili
//        titleLabel.center.x = self.view.center.x
    
        let nib = UINib(nibName: "CityWeatherViewCell", bundle: nil)
        cityTable.register(nib, forCellReuseIdentifier: "CityWeatherViewCell")
        
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTable.dequeueReusableCell(withIdentifier: "CityWeatherViewCell", for: indexPath) as! CityWeatherViewCell
//        let cloudImg = UIImage(named: "cloud")
//        cell.imageView?.image = cloudImg
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let detailedInfo_vc = storyboard?.instantiateViewController(identifier: "detailedInfo_vc") as? DetailedInfoController else{
//            return
//        }
//        present(detailedInfo_vc, animated: true)
        performSegue(withIdentifier: "detailedInfo_segue", sender: nil)
    }
    
    
}

struct Weather {
    let city:String?
    var temp:Double?
}



