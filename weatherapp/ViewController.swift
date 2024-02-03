//
//  ViewController.swift
//  weatherapp
//
//  Created by Mishel on 03.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getWeatherButtonTapped(_ sender: Any) {
        guard let city = cityTextField.text else {
                 return
             }
             
             getWeatherData(city: city)
    }
    func getWeatherData(city: String) {
        let apiKey = "a5ee3113cfceb38fd98800cdd47113ee"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                let temperature = Int(weatherData.main.temp)
                let description = weatherData.weather.first?.description ?? ""
                let icon = weatherData.weather.first?.icon ?? ""
                
                DispatchQueue.main.async {
                    self.temperatureLabel.text = "\(temperature)°C"
                    self.descriptionLabel.text = description
                    
                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon).png") {
                        URLSession.shared.dataTask(with: iconURL) { (iconData, _, _) in
                            if let data = iconData, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.weatherImageView.image = image
                                }
                            }
                        }.resume()
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
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
