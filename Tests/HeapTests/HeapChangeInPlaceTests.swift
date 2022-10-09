//
//  HeapChangeInPlaceTests.swift
//  
//
//  Created by Hristo Doichev on 10/30/21.
//

import XCTest
@testable import Heap

typealias MyHeap = Heap<Int>

final class HeapChangeInPlaceTests: XCTestCase {
    let source = [100, 36, 19, 17, 12,
                  25, 5, 9, 15, 6, 11,
                  13, 8, 1, 4, 43, 56,
                  2, 7, 42, 27, 12, 91]
    func testHeap_Init() throws {
        let v = MyHeap(source)
        XCTAssertEqual(100, v.top, "Top is 100")
        v.dumpHeap()
        print("Valid: ",v.validate())
    }
    func testHeap_Push() throws {
        let v = MyHeap(<)
        for i in source.reversed(){
            v.push(i)
        }
        XCTAssertEqual(1, v.top, "Top is 1")
        v.dumpHeap()
        print("Valid: ",v.validate())
        
        v._h[0] += 555
        v.siftDown()
        XCTAssertEqual(2, v.top, "Top is 2")
        v.dumpHeap()
        print("Valid: ",v.validate())

    }
}
