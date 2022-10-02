//
//  File.swift
//  
//
//  Created by Hristo Doichev on 10/2/22.
//

import Foundation
import XCTest
@testable import Heap

struct A: CustomStringConvertible, IndexAssignable {
    var description: String { "(k: \(_k), v: \(_v), a: \(_assignedIndex))" }
    var assignedIndex: Int {
        get { _assignedIndex }
        set { _assignedIndex = newValue }
    }
    static func < (lhs: A, rhs: A) -> Bool {
        return lhs._k < rhs._k
    }
    init(_ k: Int, _ v: Int = 0) { _k = k; _v = v }
    var _k: Int = 0
    var _v: Int = 0
    var _assignedIndex = 0
}

typealias MyDHeap = DHeap<A>

final class DHeapTests: XCTestCase {
    let source = [A(100), A(36), A(19), A(17), A(12),
                  A(25), A(5), A(9), A(15), A(6), A(11),
                  A(13), A(8), A(1), A(4), A(43), A(56),
                  A(2), A(7), A(42), A(27), A(12), A(91)]
    func testHeap_Init() throws {
        let v = MyDHeap(source)
        XCTAssertEqual(100, v.top?._k, "Top is 100")
        v.dumpHeap()
        print("Valid(pushed): ",v.validate())
    }
    func testHeap_UpdateTopInPlace() throws {
        let v = MyDHeap(source, <)

        XCTAssertEqual(1, v.top?._k, "Top is 1")
        v.dumpHeap()
        print("Valid(pushed): ",v.validate())
        
        v._h[0]._k += 555
        v.siftDown()
        XCTAssertEqual(2, v.top?._k, "Top is 2")
        v.dumpHeap()
        print("Valid(pushed): ",v.validate())
        
    }
    func testHeap_UpdateMiddleInPlace() throws {
//        let v = MyDHeap(source, <)
        let v = MyDHeap([A(1), A(2), A(3), A(4), A(5)], <)
        // update the element at (index) and then update the heap - siftDown from 'at'
        // This will keep the heap valid, by updating just a portion of the heap.
        v.update(at: 1){
            $0._k += 555
        }
        XCTAssertEqual(1, v.top?._k, "Top is 1")
        v.dumpHeap()
        print("Valid(pushed): ",v.validate())
    }
}
