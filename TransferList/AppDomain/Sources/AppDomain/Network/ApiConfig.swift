//
//  ApiConfig.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

struct ApiConfig {
    static var host: String {
          guard let url = Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String else {
              fatalError("API_HOST not found in Info.plist")
          }
          return url
      }
  }
