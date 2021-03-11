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


struct WeatherRequest {
    let resourceURL:URL
    let apiKEY = "b4fabebb89251b0e1dfa59900ad7423f"
    

    init(cityName:String){
        
        let resourceString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKEY)"
    
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    // getWeather
    func getWeather(completiton: @escaping(Result<Weather, WeatherError>)->Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL){data,_,_ in
            guard let jsonData = data else{
                completiton(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(Weather.self, from: jsonData)
                completiton(.success(weatherResponse))
            } catch{
                completiton(.failure(.cantProcessData))
            }
            
        }
        dataTask.resume()
    }
    
}
