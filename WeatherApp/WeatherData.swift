//
//  WeatherData.swift
//  WeatherApp
//
//  Created by ilomidze on 09.03.21.
//

import Foundation


struct WeatherReq:Decodable {
    var weather:[Weather]
    var main:Main
    var wind:Wind
    var coord:Coord
    var name:String
}

struct Weather:Decodable {
    var id:Int
    var main:String
    var description:String
    var icon:String
}

struct Main:Decodable {
    var temp:Double
    var feels_like:Double
    var temp_min:Double
    var temp_max:Double
    var humidity:Int
    var pressure:Int
}

struct Wind:Decodable {
    var speed:Double
}

struct Coord:Decodable {
    var lon:Double
    var lat:Double
}
