//
//  AstrologicalSignView.swift
//  Green Thumb
//
//  Created by Jared on 3/17/23.
//

import SwiftUI

struct HoroscopeView: View {
    
    // MARK: - Properties
    
    let plant: UserPlant
    
    @State private var currentDate = "Current Date"
    @State private var dateRange = "Date Range"
    @State private var description = "Description"
    @State private var mood = "Mood"
    var sign: String {
        plant.signString ?? "Aries"
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Sign: \(sign)")
                    Text("Mood: \(mood)")
                    Text("Current Date: \(currentDate)")
                    Text("Description: \(description)")
                }
            }
            .onAppear {
                getHoroscope()
            }
            .navigationTitle("Horoscope \(sign)")
        }
    }
    
    // MARK: - Functions
    
    func getHoroscope() {
        let url = URL(string: "https://aztro.sameerkumar.website/?sign=\(sign.lowercased())&day=today")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data, error == nil else {
                print("Error retrieving data.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(Horoscope.self, from: data)
                self.description = result.description
                self.currentDate = result.currentDate
                self.mood = result.mood
                self.dateRange = result.dateRange
            } catch {
                print("error")
            }
        })
        task.resume()
    }
}

func getSign(date: Date) -> (text: String, emoji: String) {
    let year = Calendar.current.component(.year, from: date)
    
    let aquarius: Date = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 21))!
    let pisces = Calendar.current.date(from: DateComponents(year: year, month: 2, day: 19))!
    let aries = Calendar.current.date(from: DateComponents(year: year, month: 3, day: 21))!
    let taurus = Calendar.current.date(from: DateComponents(year: year, month: 4, day: 20))!
    let gemini = Calendar.current.date(from: DateComponents(year: year, month: 5, day: 21))!
    let cancer = Calendar.current.date(from: DateComponents(year: year, month: 6, day: 21))!
    let leo = Calendar.current.date(from: DateComponents(year: year, month: 7, day: 23))!
    let virgo = Calendar.current.date(from: DateComponents(year: year, month: 8, day: 23))!
    let libra = Calendar.current.date(from: DateComponents(year: year, month: 9, day: 23))!
    let scorpio = Calendar.current.date(from: DateComponents(year: year, month: 10, day: 23))!
    let sagittarius = Calendar.current.date(from: DateComponents(year: year, month: 11, day: 22))!
    let capricorn = Calendar.current.date(from: DateComponents(year: year, month: 12, day: 21))!
    
    if date >= aquarius && date < pisces {
        return ("Aquarius", "♒️")
    } else if date >= pisces && date < aries {
        return ("Pisces", "♓️")
    } else if date >= aries && date < taurus {
        return ("Aries", "♈️")
    } else if date >= taurus && date < gemini {
        return ("Taurus", "♉️")
    } else if date >= gemini && date < cancer {
        return ("Gemini", "♊️")
    } else if date >= cancer && date < leo {
        return ("Cancer", "♋️")
    } else if date >= leo && date < virgo {
        return ("Leo", "♌️")
    } else if date >= virgo && date < libra {
        return ("Virgo", "♍️")
    } else if date >= libra && date < scorpio {
        return ("Libra", "♎️")
    } else if date >= scorpio && date < sagittarius {
        return ("Scorpio", "♏️")
    } else if date >= sagittarius && date < capricorn {
        return ("Sagittarius", "♐️")
    } else {
        return ("Capricorn", "♑️")
    }
}

struct Horoscope: Decodable {
    let currentDate: String
    let mood: String
    let dateRange: String
    let description: String
}
