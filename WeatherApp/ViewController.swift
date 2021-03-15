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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    
    var cityName = ""
    var cityNamesArr = [String]()
    var weatherData = [WeatherReq](){
        didSet{
            DispatchQueue.main.async {
                self.cityTable.reloadData()
                self.searchBar.endEditing(true)
                self.searchBar.text = ""
                
                self.view.isUserInteractionEnabled = true
                self.spinner.stopAnimating()
                self.defaultsUpdate()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forecast"
        
        searchBar.delegate = self
        cityTable.delegate = self
        cityTable.dataSource = self
        
        spinner.hidesWhenStopped = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.cityTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let nib = UINib(nibName: "CityWeatherViewCell", bundle: nil)
        cityTable.register(nib, forCellReuseIdentifier: "CityWeatherViewCell")
        
        defaultsLoad()
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete){
            weatherData.remove(at: indexPath.row)
            cityNamesArr.remove(at: indexPath.row)
            self.cityTable.reloadData()
        }
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
        
        if(isAdded(city: cityName)){
            DispatchQueue.main.async {
                self.showAlert(show: self.cityName)
                return
            }
            self.searchBar.text = ""
            return
        }

        cityNamesArr.append(self.cityName)
        
        self.view.isUserInteractionEnabled = false
        self.spinner.startAnimating()
        
        requestData(cityName: self.cityName)
    }
    
    
    func requestData(cityName:String){
        
        var weatherRequest = WeatherRequest()
        weatherRequest.createURL(cityName: cityName)
        weatherRequest.getWeather() { [weak self] result in
            switch result{
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.showAlert(show: "\(error.localizedDescription)")
                    self?.cityNamesArr.remove(at: (self?.cityNamesArr.count)!-1)
                }

            case .success(let weather):
//                self?.weatherData.append(weather)
                
                self?.weatherData.insert(weather, at: 0)
            }
        }
    }
    
    
    func isAdded(city:String) -> Bool {
        for info in weatherData {
            let addedCity = info.name
            if addedCity == city{
                return true
            }
        }
        return false
    }
    
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    func showAlert(show message:String){
        let alert = UIAlertController(title: "Can't Add City", message: "This city has already been added", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.spinner.stopAnimating()
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    func defaultsUpdate(){
        self.defaults.set(self.cityNamesArr, forKey: "cityNamesArr")
    }
    
    
    func defaultsLoad(){
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        self.cityNamesArr = self.defaults.object(forKey: "cityNamesArr") as? [String] ?? [String]()
        
        for cityName_i in self.cityNamesArr {
            requestData(cityName: cityName_i)
        }
        
        self.cityTable.reloadData()
        
        self.spinner.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    
}




