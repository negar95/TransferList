//
//  UserDefaultTests.swift
//  AppFoundation
//
//  Created by Negar Moshtaghi on 8/25/25.
//

import XCTest
import Combine
@testable import AppFoundation

final class UserDefaultTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        cancellables = []
        defaults = UserDefaults(suiteName: "UserDefaultTests")
        defaults.removePersistentDomain(forName: "UserDefaultTests")
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: "UserDefaultTests")
        defaults = nil
        cancellables = nil
        super.tearDown()
    }

    func test_wrappedValue_readsAndWrites() {
        var wrapper = UserDefault(\.testStringArray, storage: defaults)
        var arr = wrapper.wrappedValue
        arr.append("Hello")
        wrapper.wrappedValue = arr

        XCTAssertEqual(wrapper.wrappedValue, ["Hello"])
        XCTAssertEqual(defaults.testStringArray, ["Hello"])
    }

    @MainActor
    func test_projectedValue_publishesChanges() {
        var wrapper = UserDefault(\.testStringArray, storage: defaults)
        let exp = expectation(description: "Publisher should emit new values")
        var receivedValues: [[String]] = []

        wrapper.projectedValue
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        var arr = wrapper.wrappedValue
        arr.append("First")
        wrapper.wrappedValue = arr

        arr.append("Second")
        wrapper.wrappedValue = arr
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, [[], ["First"], ["First", "Second"]])
    }

    @MainActor
    func test_projectedValue_removesDuplicates() {
        var wrapper = UserDefault(\.testStringArray, storage: defaults)
        let exp = expectation(description: "Publisher should ignore duplicate values")
        var receivedValues: [[String]] = []

        wrapper.projectedValue
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        // Trigger values by replacing
        var arr = wrapper.wrappedValue
        arr.append("Same")
        wrapper.wrappedValue = arr

        wrapper.wrappedValue = arr // duplicate, should be ignored

        arr.append("New")
        wrapper.wrappedValue = arr

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValues, [[], ["Same"], ["Same", "New"]])
    }
}

// MARK: - Helpers
extension UserDefaults {
    @objc dynamic var testStringArray: [String] {
        get { stringArray(forKey: "testStringArray") ?? [] }
        set { set(newValue, forKey: "testStringArray") }
    }
}
