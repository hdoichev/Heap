//
//  Heap.swift
//
//
//  Created by Hristo Doichev on 9/26/19.
//  Copyright © 2019 Hristo Doichev. All rights reserved.
//

import Foundation

/**
 */
public class Heap<T:Comparable> {
    public typealias Storage = ContiguousArray<T>
    var _compare:(T,T)->Bool = (>)
    //
    var _h = Storage()
    /// return the count of elements in the Heap
    public var count:Int { return _h.count }
    /// Access the internal storage.
    public var storage: Storage { return _h }
    /// Access the top element.
    public var top:T? { return _h.first }
    /// Create a Heap with default comparitor '>'.
    public init(_ compare:@escaping ((T, T)->Bool) = (>)){
        _compare = compare
        
    }
    /// Create a Heap with a given source and default compare operator '>'
    public init(_ h:Storage, _ compare:@escaping ((T, T)->Bool) = (>)){
        _compare = compare
        _h = h
        heapifySiftDown()
//        heapifySiftUp()
    }
    public convenience init(_ h:Array<T>, _ compare:@escaping ((T, T)->Bool) = (>)){
        self.init(Storage(h), compare)
    }
    /// Access storage using a closure.
    public func accessStorage(_ block: (inout Storage)->Void) {
        block(&_h)
    }
    ///
    public func push(_ v:T){
        _h.append(v)
        let end = _h.count-1
        siftUp(start: (end - 1) / 2, end: end)
    }
    /// Pop the top most element and update the heap order.
    public func pop(){
        if _h.count > 0 {
            _h.swapAt(0, _h.count-1)
            _h.remove(at: _h.count-1)
            siftDown(root:0, end:_h.count-1)
        }
    }
    /// Heapify from the bottom up
    public func heapifySiftUp(){
        _h.withUnsafeMutableBufferPointer { (storage) in
            for i in 1..<storage.count{
                _siftUp(start:(i - 1) / 2, end: i, storage: storage)
            }
        }
    }
    /// Heapify from the top down.
    public func heapifySiftDown(){
        let end = _h.count - 1
        _h.withUnsafeMutableBufferPointer { (storage) in
            for i in (0...end/2).reversed(){
                _siftDown(root:i, end: end, storage: storage)
            }
        }
    }
    /// Heapify a range
    private func siftUp(start:Int, end:Int)->Void{
        _h.withUnsafeMutableBufferPointer { (storage) in
            _siftUp(start: start, end: end, storage: storage)
        }
    }
    /// Implementation of the 'siftUp' process.
    func _siftUp(start:Int, end:Int, storage: UnsafeMutableBufferPointer<T>){
        if start < 0 || start >= end {
            return
        }
        if _compare(storage[end], storage[start]) {
            storage.swapAt(start, end)
            _siftUp(start: (start - 1) / 2, end:start, storage: storage)
        }
    }
    /// Sift down.
    public func siftDown() {
        siftDown(root: 0, end: _h.count - 1)
    }
    /// Sift down with range.
    func siftDown(root: Int, end: Int)->Void{
        _h.withUnsafeMutableBufferPointer { (storage) in
            _siftDown(root: root, end: end, storage: storage)
        }
    }
    /// Implementation of 'siftDown' process.
    func _siftDown(root:Int, end:Int, storage:UnsafeMutableBufferPointer<T>)->Void{
        var b = (root * 2) + 1
        if b > end { return }
        if end > b {
            if _compare(storage[b+1], storage[b]) {
                b += 1
            }
        }
        if _compare(storage[b], storage[root]) {
            swap(b, root, storage)
//            storage.swapAt(b, root)
            _siftDown(root:b, end:end, storage: storage)
        }
    }
    /// 
    func swap(_ a: Int, _ b: Int, _ storage: UnsafeMutableBufferPointer<T>) {
        storage.swapAt(a, b)
    }
}


extension Heap: CustomStringConvertible {
    public var description: String {
        "\(_h.count): \(_h)"
    }
}
