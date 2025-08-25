//
//  TransferViewModelTests.swift
//  TransferViewModelTests
//
//  Created by Negar Moshtaghi on 8/21/25.
//
//
//  TransferViewModelTests.swift
//  AppFoundation
//

import XCTest
import Combine
import AppDomain
@testable import TransferList

@MainActor
final class TransferViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func test_addFavorite_updatesDetailSection() {
        let response = DestinationResponse.mock()
        let viewModel = TransferViewModel(response: response, isFavorite: false)

        let exp = expectation(description: "DetailSection updated")
        viewModel.state
            .dropFirst()
            .sink { state in
                if let section = state.detailSection,
                   section.items.first?.cellData.buttonImage == .filledStar {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.action(.addFavorite(response.id))

        waitForExpectations(timeout: 1)
        XCTAssertEqual(viewModel.stateValue.detailSection?.items.first?.cellData.title, response.person.fullName)
    }

    func test_removeFavorite_updatesDetailSection() {
        let response = DestinationResponse.mock()
        let viewModel = TransferViewModel(response: response, isFavorite: true)

        let exp = expectation(description: "DetailSection updated")
        viewModel.state
            .dropFirst()
            .sink { state in
                if let section = state.detailSection,
                   section.items.first?.cellData.buttonImage == .star {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.action(.removeFavorite(response.id))

        waitForExpectations(timeout: 1)
        XCTAssertEqual(viewModel.stateValue.detailSection?.items.first?.cellData.title, response.person.fullName)
    }
}
