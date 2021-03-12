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
                
                self.cityTable.beginUpdates()
                self.cityTable.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                self.cityTable.endUpdates()
            }

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController!.title?.append("Forecast")
        
        searchBar.delegate = self
        cityTable.delegate = self
        cityTable.dataSource = self
        
        let nib = UINib(nibName: "CityWeatherViewCell", bundle: nil)
        cityTable.register(nib, forCellReuseIdentifier: "CityWeatherViewCell")
        
        
    }
    

}

//: ViewController Class Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //: Create Empty TableView Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfRows = weatherData.count
        return numOfRows
    }
    
    //: Create Cell in TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTable.dequeueReusableCell(withIdentifier: "CityWeatherViewCell", for: indexPath) as! CityWeatherViewCell
        
//        if weatherData?.count ?? 0 > 0 {
        cell.updateCell(city: weatherData[indexPath.row].name, Temperature: (weatherData[indexPath.row].main.temp)-273.15, Condition: .sun)

//        }
        return cell
    }
    
    //: Perform Segue on selected raw in Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailedInfo_segue", sender: nil)
    }
    
    //: Update ViewController for destination segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let indexpath = cityTable.indexPathForSelectedRow else{
//            return
//        }
//        (segue.destination as? DetailedInfoController)?.updateView(city: weatherData[indexpath.row].city ?? "city", temperature: Int( weatherData[indexpath.row].temp ?? 0), condition: weatherData[indexpath.row].condition ?? WeatherCond.sun)
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
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


