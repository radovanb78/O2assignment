//
//  O2assignmentTestsFullFlowWithActivationSuccess.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import XCTest
@testable import O2assignment

final class O2assignmentTestsFullFlowWithActivationSuccess: XCTestCase {
    var store: ScratchCardStore!

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            store = ScratchCardStore(
                service: MockNetworkService(responseData: ActivationResponse(ios: "6.42.1")),
                exclusiveMin: "6.1"
            )
        }
    }

    override func tearDown() async throws{
        try await super.tearDown()
    }

    func test() async {
        // test generate code
        let code = try? await store.generateCode()
        XCTAssertNotNil(code)
        await MainActor.run {
            XCTAssertFalse(store.isScratched)
            XCTAssertTrue(store.state == .unscratched)
            XCTAssertTrue(store.canScratch)
            XCTAssertNotNil(store.code)
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
        let result = await store.activate()
        XCTAssertTrue(result)
        await MainActor.run {
            XCTAssertTrue(store.isScratched)
            XCTAssertFalse(store.canScratch)
            XCTAssertTrue(store.state == .activated)
            XCTAssertNotNil(store.code)
        }
    }
}
