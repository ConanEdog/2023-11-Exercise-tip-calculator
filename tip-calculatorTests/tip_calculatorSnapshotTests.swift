//
//  tip_calculatorSnapshotTests.swift
//  tip-calculatorTests
//
//  Created by 方奎元 on 2023/11/8.
//

import XCTest
import SnapshotTesting
@testable import tip_calculator

final class tip_calculatorSnapshotTests: XCTestCase {
    
    private var screenWidth: CGFloat {
        return UIScreen().bounds.size.width
    }
    
    func testLogoView() {
        //given
        let size = CGSize(width: screenWidth, height: 48)
        //when
        let view = LogoView()
        //then
        assertSnapshot(of: view, as: .image(size: size), record: true)
    }
}
