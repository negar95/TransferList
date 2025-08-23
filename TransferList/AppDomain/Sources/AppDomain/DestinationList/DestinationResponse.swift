//
//  DestinationResponse.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

public struct DestinationResponse: Codable, Sendable {
    let person: Person
    let card: Card
    let lastTransfer: Date
    let note: String?
    let moreInfo: MoreInfo

    enum CodingKeys: String, CodingKey {
        case person, card, note
        case lastTransfer = "last_transfer"
        case moreInfo = "more_info"
    }

    struct Person: Codable {
        let fullName: String
        let email: String?
        let avatar: URL

        enum CodingKeys: String, CodingKey {
            case fullName = "full_name"
            case email, avatar
        }
    }
    struct Card: Codable {
        let cardNumber: String
        let cardType: String

        enum CodingKeys: String, CodingKey {
            case cardNumber = "card_number"
            case cardType = "card_type"
        }
    }
    struct MoreInfo: Codable {
        let numberOfTransfers: Int
        let totalTransfer: Int

        enum CodingKeys: String, CodingKey {
            case numberOfTransfers = "number_of_transfers"
            case totalTransfer = "total_transfer"
        }
    }
}
