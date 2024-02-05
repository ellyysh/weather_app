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
       }

       @IBAction func getWeatherButtonTapped(_ sender: Any) {
           guard let city = cityTextField.text else {
               return
           }

           WeatherService.shared.getWeatherData(city: city) { result in
               switch result {
               case .success(let weatherData):
                   self.updateUI(with: weatherData)
               case .failure:
                   self.showErrorAlert(message: "Не удалось загрузить данные о погоде")
               }
           }
       }

       private func updateUI(with weatherData: WeatherData) {
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
       }

    private func showErrorAlert(message: String) {
       DispatchQueue.main.async {
           let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(okAction)
           self.present(alert, animated: true, completion: nil)
       }
    }


   }

