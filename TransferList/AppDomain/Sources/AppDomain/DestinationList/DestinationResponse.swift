//
//  DestinationResponse.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

public struct DestinationResponse: Codable, Sendable, Equatable {
    public var id: String { fullName + (email ?? "nil") }
    public var fullName: String { person.fullName }
    public var email: String? { person.email }
    public var image: URL? { person.avatar }

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

    struct Person: Codable, Equatable {
        let fullName: String
        let email: String?
        let avatar: URL?

        enum CodingKeys: String, CodingKey {
            case fullName = "full_name"
            case email, avatar
        }
    }
    struct Card: Codable, Equatable {
        let cardNumber: String
        let cardType: String

        enum CodingKeys: String, CodingKey {
            case cardNumber = "card_number"
            case cardType = "card_type"
        }
    }
    struct MoreInfo: Codable, Equatable {
        let numberOfTransfers: Int
        let totalTransfer: Int

        enum CodingKeys: String, CodingKey {
            case numberOfTransfers = "number_of_transfers"
            case totalTransfer = "total_transfer"
        }
    }
}
