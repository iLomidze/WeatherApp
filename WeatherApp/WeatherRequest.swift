//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by ilomidze on 09.03.21.
//

import Foundation

enum WeatherError:Error{
    case noDataAvailable
    case cantProcessData
}


struct WeatherRequest{
    var resourceURL:URL?
    let apiKEY = "b4fabebb89251b0e1dfa59900ad7423f"
    
    // getWeather
    func getWeather(completiton: @escaping(Result<WeatherReq, WeatherError>)->Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL!){data,_,_ in
            guard let jsonData = data else{
                completiton(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherReq.self, from: jsonData)
                completiton(.success(weatherResponse))
            } catch{
                completiton(.failure(.cantProcessData))
            }
            
        }
        dataTask.resume()
    }
    
    mutating func createURL(cityName:String){
        var resourceString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKEY)"
        resourceString = resourceString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? resourceString

        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    
    }
    
}
