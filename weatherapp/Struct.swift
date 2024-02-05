//
//  Struct.swift
//  weatherapp
//
//  Created by Mishel on 05.02.2024.
//

import Foundation
struct WeatherData: Codable {
    let main: WeatherMain
    let weather: [Weather]
}

struct WeatherMain: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
