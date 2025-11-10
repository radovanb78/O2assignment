//
//  O2assignmentTestsFullFlowWithActivationFailure.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import XCTest
@testable import O2assignment

final class O2assignmentTestsFullFlowWithActivationFailure: XCTestCase {
    var store: ScratchCardStore!

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            store = ScratchCardStore(
                service: MockNetworkService(responseData: ActivationResponse(ios: "6.0")),
                exclusiveMin: "6.1"
            )
        }
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    func test() async throws {
        // test initial state
        await MainActor.run {
            XCTAssertTrue(store.state == .unscratched)
            XCTAssertFalse(store.isScratched)
            XCTAssertNil(store.code)
        }

        // test scratch without generate first
        await MainActor.run {
            store.setScratched()
            XCTAssertTrue(store.state == .unscratched)
            XCTAssertFalse(store.isScratched)
        }

        // test generate code
        let code = try await store.generateCode()
        XCTAssertFalse(code.isEmpty)
        await MainActor.run {
            XCTAssertTrue(store.state == .unscratched)
            XCTAssertTrue(store.canScratch)
            XCTAssertNotNil(store.code)
        }

        // test activate without scratch first
        let result0 = await store.activate()
        XCTAssertFalse(result0)
        await MainActor.run {
            XCTAssertTrue(store.state == .unscratched)
        }

        // test scratch
        await MainActor.run {
            store.setScratched()
            XCTAssertTrue(store.isScratched)
            XCTAssertTrue(store.state == .scratched)
            XCTAssertFalse(store.canScratch)
            XCTAssertNotNil(store.code)
        }

        // test activate
        let result1 = await store.activate()
        XCTAssertFalse(result1)
        await MainActor.run {
            XCTAssertFalse(store.state == .activated)
            XCTAssertNotNil(store.code)
        }
    }
}
