//
//  Heap.swift
//
//
//  Created by Hristo Doichev on 9/26/19.
//  Copyright © 2019 Hristo Doichev. All rights reserved.
//

import Foundation

public protocol IndexAssignable: Comparable {
    var assignedIndex: Int { get set }
}
/**
 */
public class Heap<T:Comparable> {
    public typealias Storage = ContiguousArray<T>
    var _compare:(T,T)->Bool = (>)
    var _h = Storage()
    var count:Int { return _h.count }
    
    public var top:T? { return _h.first }
    
    public init(_ compare:@escaping ((T, T)->Bool) = (>)){
        _compare = compare
        
    }
    public init(_ h:Storage, _ compare:@escaping ((T, T)->Bool) = (>)){
        _compare = compare
        _h = h
        heapifySiftDown()
//        heapifySiftUp()
    }
    public convenience init(_ h:Array<T>, _ compare:@escaping ((T, T)->Bool) = (>)){
        self.init(Storage(h), compare)
    }
    ///
    public func accessStorage(_ block: (inout Storage)->Void) {
        block(&_h)
    }
    ///
    public func push(_ v:T){
        _h.append(v)
        let end = _h.count-1
        siftUp(start: (end - 1) / 2, end: end)
    }
    public func pop(){
        if _h.count > 0 {
            _h.swapAt(0, _h.count-1)
            _h.remove(at: _h.count-1)
            siftDown(root:0, end:_h.count-1)
        }
    }
    public func heapifySiftUp(){
        //        for i in 1..<(_h.count){
        //            siftUp(start:(i - 1) / 2, end: i)
        //        }
        _h.withUnsafeMutableBufferPointer { (storage) in
            for i in 1..<storage.count{
                _siftUp(start:(i - 1) / 2, end: i, storage: storage)
            }
        }
    }
    public func heapifySiftDown(){
        let end = _h.count - 1
        _h.withUnsafeMutableBufferPointer { (storage) in
            for i in (0...end/2).reversed(){
                _siftDown(root:i, end: end, storage: storage)
            }
        }
        //        for i in (0...end/2).reversed(){
        //            siftDown(root:i, end: end)
        //        }
    }
    private func siftUp(start:Int, end:Int)->Void{
        _h.withUnsafeMutableBufferPointer { (storage) in
            _siftUp(start: start, end: end, storage: storage)
        }
        //        if start < 0 || start >= end {
        //            return
        //        }
        //        if _compare(_h[end], _h[start]) {
        //            _h.swapAt(start, end)
        //            siftUp(start: (start - 1) / 2, end:start)
        //        }
    }
    func _siftUp(start:Int, end:Int, storage: UnsafeMutableBufferPointer<T>){
        if start < 0 || start >= end {
            return
        }
        if _compare(storage[end], storage[start]) {
            storage.swapAt(start, end)
            _siftUp(start: (start - 1) / 2, end:start, storage: storage)
        }
    }
    public func siftDown() {
        siftDown(root: 0, end: _h.count - 1)
    }
    func siftDown(root: Int, end: Int)->Void{
        _h.withUnsafeMutableBufferPointer { (storage) in
            _siftDown(root: root, end: end, storage: storage)
        }
        //        var b = (root * 2) + 1
        //        if b > end { return }
        //        if end > b {
        //            if _compare(_h[b+1], _h[b]) {
        //                b += 1
        //            }
        //        }
        //        if _compare(_h[b], _h[root]) {
        //            _h.swapAt(b, root)
        //            siftDown(root:b, end:end)
        //        }
    }
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
    //    private func siftDown(start:Int, end:Int)->Void{
    //        let b = start * 2
    //        if b >= end { return }
    //        var i = 1
    //        if (end - b) > 1 {
    //            if _compare(_h[b+2], _h[b+1]) {
    //                i = 2
    //            }
    //        }
    //        if _compare(_h[b+i], _h[start]) {
    //            _h.swapAt(b+i, start)
    //            siftDown(start:b+i, end:end)
    //        }
    //    }
    func swap(_ a: Int, _ b: Int, _ storage: UnsafeMutableBufferPointer<T>) {
        storage.swapAt(a, b)
    }
}

public class DHeap<T: IndexAssignable> : Heap<T> {
    public func siftDown(root: Int) {
        siftDown(root: root, end: _h.count - 1)
    }
    override func _siftUp(start:Int, end:Int, storage: UnsafeMutableBufferPointer<T>){
        if start < 0 || start >= end {
            return
        }
        storage[start].assignedIndex = start
        storage[end].assignedIndex = end
        if _compare(storage[end], storage[start]) {
            swap(start, end, storage)
            _siftUp(start: (start - 1) / 2, end:start, storage: storage)
        }
    }
    override func _siftDown(root:Int, end:Int, storage: UnsafeMutableBufferPointer<T>)->Void{
        var b = (root * 2) + 1
        if b > end { return }
        storage[root].assignedIndex = root
        storage[b].assignedIndex = b
        if end > b {
            if _compare(storage[b+1], storage[b]) {
                b += 1
                storage[b].assignedIndex = b
            }
        }
        if _compare(storage[b], storage[root]) {
            swap(b, root, storage)
            _siftDown(root:b, end:end, storage: storage)
        }
    }
    override func swap(_ a: Int, _ b: Int, _ storage: UnsafeMutableBufferPointer<T>) {
        storage.swapAt(a, b)
        storage[a].assignedIndex = a
        storage[b].assignedIndex = b
    }
}
