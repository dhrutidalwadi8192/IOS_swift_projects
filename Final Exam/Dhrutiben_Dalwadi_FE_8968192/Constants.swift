//
//  Constants.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/13/24.
//

import Foundation

// APP Constants
struct Constants {
    // weather API Keys
    static let weatherApiKey = "e68ee396fa496b330c4e8158ab739ead"
    static let weatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let weatherIconUrl = "https://openweathermap.org/img/wn/"
    
    // News API Keys
    static var newsAPIKey = "605f482e178d48ebb22731f683fe2e3e"
    static var newsAPIBaseUrl = "https://newsapi.org/v2/everything"
    
    
    // Interction types
    struct InteractionType{
        static let MAIN = "Main"
        static let WEATHER = "Weather"
        static let NEWS = "News"
        static let MAP = "Map"
    }
    
}
