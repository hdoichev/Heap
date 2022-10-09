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

/// A `Heap` where the elements can keep track of their own position within the
/// `Heap`s storage.
/// This can be usfull in cases where an element (other than `top` or `bottom`) in the middle of the `Heap` has to be updated.
///
/// This allows the `Heap` to be updated starting at some arbitrary location, rather than `top` or `bottom`
///
///     struct A: IndexAssignable {
///     var assignedIndex: Int {
///         get { _assignedIndex }
///         set { _assignedIndex = newValue }
///     }
///     static func < (lhs: A, rhs: A) -> Bool {
///         return lhs._k < rhs._k
///     }
///     init(_ k: Int) { _k = k }
///     var _k: Int
///     var _assignedIndex = 0
///     }
///
///     let v = MyDHeap([A(3), A(2), A(1), A(4), A(5), A(6)], <)
///     // Update the key of the second element (location = 1) and also refresh the order
///     // of the heap starting at the same location.
///     v.update(at: 1){
///         $0._k += 555
///     }
///
///     The above will push the second element further down the Heap, without having to Heapify
///     the entire Heap.
///
public class DHeap<T: IndexAssignable> : Heap<T> {
    public enum Direction {
        case Up, Down
    }
    public func update(at: Int, direction: Direction = .Down,with closure: (inout T)->Void) {
        guard at >= 0 && at < _h.count else { return }
        closure(&_h[at])
        switch direction {
        case .Up: heapifySiftDown() // siftUp(start: 0, end: at)
        case .Down: siftDown(root: at)
        }
    }
    ///
    override func _siftUp(start:Int, end:Int, storage: UnsafeMutableBufferPointer<T>){
        guard start >= 0 && start < end else { return }

//        storage[start].assignedIndex = start
//        storage[end].assignedIndex = end
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
