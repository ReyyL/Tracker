//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Andrey Lazarev on 25.07.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image)
    }
}
