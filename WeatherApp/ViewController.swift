//
//  ViewController.swift
//  WeatherApp
//
//  Created by ilomidze on 24.02.21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var cityName = ""
    var weatherData = [WeatherReq](){
        didSet{
            DispatchQueue.main.async {
                self.cityTable.reloadData()
                self.searchBar.endEditing(true)
                self.searchBar.text = ""
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forecast"

        searchBar.delegate = self
        cityTable.delegate = self
        cityTable.dataSource = self

//        let tap = UITapGestureRecognizer(target: self, action: #selector(view.endEditing))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
        
        self.cityTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let nib = UINib(nibName: "CityWeatherViewCell", bundle: nil)
        cityTable.register(nib, forCellReuseIdentifier: "CityWeatherViewCell")
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "City Name", attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
    }
    

}

//: ViewController Class Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate{
    
    //: Create Empty TableView Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfRows = weatherData.count
        return numOfRows
    }
    
    //: Create Cell in TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTable.dequeueReusableCell(withIdentifier: "CityWeatherViewCell", for: indexPath) as! CityWeatherViewCell
        
        let tempInt = Int(round((weatherData[indexPath.row].main.temp)-273.15))
        var weatherCond = weatherData[indexPath.row].weather.first!.main
        
        if weatherData[indexPath.row].weather.first?.icon == "01n"{
            weatherCond = "Moon"
        }
        
        cell.updateCell(city: weatherData[indexPath.row].name, Temperature: tempInt, Condition: weatherCond)
        
        return cell
    }
    
    //: Perform Segue on selected raw in Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailedInfo_segue", sender: nil)
        self.cityTable.deselectRow(at: indexPath, animated: true)
    }
    
    
    //: Update ViewController for destination segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = cityTable.indexPathForSelectedRow else{
            return
        }
        let tempInt = Int(round((weatherData[indexPath.row].main.temp)-273.15))
        var weatherCond = weatherData[indexPath.row].weather.first!.main
        
        if weatherData[indexPath.row].weather.first?.icon == "01n"{
            weatherCond = "Moon"
        }
        
        (segue.destination as? DetailedInfoController)?.updateView(city: weatherData[indexPath.row].name, temperature: tempInt, condition: weatherCond, tempFeel: Int(weatherData[indexPath.row].main.feels_like - 273.15), windSpeed: Int( weatherData[indexPath.row].wind.speed), pressure: weatherData[indexPath.row].main.pressure, longitude: weatherData[indexPath.row].coord.lon, latitude: weatherData[indexPath.row].coord.lat)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.cityTable.keyboardDismissMode = .interactive
        
        guard let searchBarText = searchBar.text else {
            return
        }
        
        if searchBarText.isEmpty{
            return
        }
        
        self.cityName = searchBarText
        
        requestData()
    }
    
    
    
    
    
    func requestData(){
        let weatherRequest = WeatherRequest(cityName: self.cityName)
        weatherRequest.getWeather() { [weak self] result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let weather):
                self?.weatherData.append(weather)
//                DispatchQueue.main.async {
//                    self?.cityTable.reloadData()
//                }
                
            }
        }
    }
    
    
    
}





//: Test Data preparation ->

enum WeatherCond:CaseIterable {
    case sun, rain, cloud, snow
}

//: - Weather Structure
struct WeatherTest {
    var city:String?
    var temp:Double?
    var condition:WeatherCond?
}

//: - Creates Array of test weather data
func createTestData(dataSize:Int) -> [WeatherTest] {
    var weatherData:[WeatherTest] = []
    
    for i in 0..<dataSize {
        var singleData:WeatherTest = WeatherTest()
        singleData.city = "city \(i)"
        singleData.temp = round(Double(Float.random(in: -10..<50)))
        singleData.condition = WeatherCond.allCases.randomElement()
        
        weatherData.append(singleData)
    }
    return weatherData
}


