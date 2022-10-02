//
//  File.swift
//  
//
//  Created by Hristo Doichev on 10/2/22.
//

import Foundation

public protocol IndexAssignable: Comparable {
    var assignedIndex: Int { get set }
}

public class DHeap<T: IndexAssignable> : Heap<T> {
    public func update(at: Int, with closure: (inout T)->Void) {
        guard at >= 0 && at < _h.count else { return }
        closure(&_h[at])
        siftDown(root: at)
    }
    ///
    override func _siftUp(start:Int, end:Int, storage: UnsafeMutableBufferPointer<T>){
        guard start >= 0 && start < end && end < _h.count else { return }

        storage[start].assignedIndex = start
        storage[end].assignedIndex = end
        if _compare(storage[end], storage[start]) {
            swap(start, end, storage)
            _siftUp(start: (start - 1) / 2, end:start, storage: storage)
        }
    }
    override func _siftDown(root:Int, end:Int, storage: UnsafeMutableBufferPointer<T>)->Void{
        var b = (root * 2) + 1
        storage[root].assignedIndex = root

        guard b <= end else { return }
        storage[b].assignedIndex = b
        if end > b {
            storage[b+1].assignedIndex = b+1
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
