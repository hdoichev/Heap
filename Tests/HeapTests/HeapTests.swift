import XCTest
@testable import Heap

final class HeapTests: XCTestCase {
    func testHeap_Init() throws {
        let source = [100, 36, 19, 17, 12, 25, 5, 9, 15, 6, 11, 13, 8, 1, 4, 43, 56, 2, 7, 42, 27, 12, 91]
        let v = Heap<Int>(source)
//        for i in source.reversed(){
//            v.push(i)
//        }
        XCTAssertEqual(100, v.top, "Top is 100")
        v.dumpHeap()
        print("Valid(pushed): ",v.validate())
    }
    func testHeap_Push() throws {
        let source = [100, 36, 19, 17, 12, 25, 5, 9, 15, 6, 11, 13, 8, 1, 4, 43, 56, 2, 7, 42, 27, 12, 91]
        let v = Heap<Int>()
        for i in source.reversed(){
            v.push(i)
        }
        XCTAssertEqual(100, v.top, "Top is 100")
        v.dumpHeap()
        print("Valid(pushed): ",v.validate())
    }
}
