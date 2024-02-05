//
//  Service.swift
//  weatherapp
//
//  Created by Mishel on 05.02.2024.
//

import Foundation
class WeatherService {
    static let shared = WeatherService()

    private let apiKey = "a5ee3113cfceb38fd98800cdd47113ee"

    func getWeatherData(city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }

            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
