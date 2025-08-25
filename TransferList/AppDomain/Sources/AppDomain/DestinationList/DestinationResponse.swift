//
//  DestinationResponse.swift
//  AppDomain
//
//  Created by Negar Moshtaghi on 8/23/25.
//

import Foundation

public struct DestinationResponse: Codable, Sendable, Equatable {
    public var id: String { person.fullName + (person.email ?? "nil") }

    public let person: Person
    public let card: Card
    public let lastTransfer: Date
    public let note: String?
    public let moreInfo: MoreInfo

    public init(person: Person, card: Card, lastTransfer: Date, note: String?, moreInfo: MoreInfo) {
        self.person = person
        self.card = card
        self.lastTransfer = lastTransfer
        self.note = note
        self.moreInfo = moreInfo
    }

    enum CodingKeys: String, CodingKey {
        case person, card, note
        case lastTransfer = "last_transfer"
        case moreInfo = "more_info"
    }

    public struct Person: Codable, Sendable, Equatable {
        public let fullName: String
        public let email: String?
        public let avatar: URL?

        public init(fullName: String, email: String?, avatar: URL?) {
            self.fullName = fullName
            self.email = email
            self.avatar = avatar
        }

        enum CodingKeys: String, CodingKey {
            case fullName = "full_name"
            case email, avatar
        }
    }
    public struct Card: Codable, Sendable, Equatable {
        public let cardNumber: String
        public let cardType: String

        public init(cardNumber: String, cardType: String) {
            self.cardNumber = cardNumber
            self.cardType = cardType
        }

        enum CodingKeys: String, CodingKey {
            case cardNumber = "card_number"
            case cardType = "card_type"
        }
    }
    public struct MoreInfo: Codable, Sendable, Equatable {
        public let numberOfTransfers: Int
        public let totalTransfer: Int

        public init(numberOfTransfers: Int, totalTransfer: Int) {
            self.numberOfTransfers = numberOfTransfers
            self.totalTransfer = totalTransfer
        }

        enum CodingKeys: String, CodingKey {
            case numberOfTransfers = "number_of_transfers"
            case totalTransfer = "total_transfer"
        }
    }
}
