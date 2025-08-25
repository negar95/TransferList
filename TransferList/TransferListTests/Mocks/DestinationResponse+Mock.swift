//
//  DestinationResponse+Mock.swift
//  TransferList
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import Foundation
import AppDomain

extension DestinationResponse {
    static func mock(
        fullName: String = "Full Name",
        email: String? = "email@example.com",
        avatar: URL? = nil,
        cardNumber: String = "1234567890123456",
        cardType: String = "Visa",
        lastTransfer: Date = Date(),
        note: String? = "Sample note",
        numberOfTransfers: Int = 5,
        totalTransfer: Int = 1000
    ) -> DestinationResponse {
        let person = Person(fullName: fullName, email: email, avatar: avatar)
        let card = Card(cardNumber: cardNumber, cardType: cardType)
        let moreInfo = MoreInfo(numberOfTransfers: numberOfTransfers, totalTransfer: totalTransfer)
        return DestinationResponse(
            person: person,
            card: card,
            lastTransfer: lastTransfer,
            note: note,
            moreInfo: moreInfo
        )
    }
}
