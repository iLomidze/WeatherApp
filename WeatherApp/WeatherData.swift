//
//  WeatherData.swift
//  WeatherApp
//
//  Created by ilomidze on 09.03.21.
//

import Foundation


struct Weather:Decodable {
    var id:Int
    var main:String
    var description:String
    var icon:String
}
