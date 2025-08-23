//
//  APIConfig.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

struct APIConfig {
    static var baseURL: String {
          guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
              fatalError("API_BASE_URL not found in Info.plist")
          }
          return url
      }
  }
