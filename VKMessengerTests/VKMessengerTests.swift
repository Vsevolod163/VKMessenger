//
//  VKMessengerTests.swift
//  VKMessengerTests
//
//  Created by Vsevolod Lashin on 28.07.2023.
//

import XCTest
@testable import VKMessenger

final class VKMessengerTests: XCTestCase {

    var sut: FriendsViewController!
    
    var items: [String] = []
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        
        super.tearDown()
    }

    func testExample() {
        
    }

    func testPerformanceExample() {
        measure {
            getMoreItems()
        }
    }
    
    private func getItems() {
        let numbers = 1...1_000_000
        
        for number in numbers {
            let item = "Item: \(number)"
            items.append(item)
        }
    }
    
    private func getMoreItems() {
        items = (1...1_000_000).map {"Item: \($0)" }
    }
}
