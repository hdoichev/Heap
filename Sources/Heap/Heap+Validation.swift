//
//  Heap+Validation.swift
//  
//
//  Created by Hristo Doichev on 10/29/21.
//

import Foundation

/// Heap validation functionality.
/// Detect if Heap is corrupted and also provide the 'path' (within the heap) where the corrupted item is detected.
extension Heap {
    func validate()->(Bool,[Int]){
        var errPath = [Int]()
        let isValid = probeForValidity(root: 0, end: _h.count-1, errPath: &errPath)
        return (isValid, errPath.reversed())
    }
    private func probeForValidity(root:Int, end:Int, errPath:inout [Int])->Bool{
        let left = (root * 2) + 1
        guard left <= end else {return true}
        let right = left + 1
        
        if _compare(_h[left], _h[root])  { errPath.append(left); errPath.append(root); return false }
        if right <= end {
            if _compare(_h[right], _h[root]) { errPath.append(right); errPath.append(root); return false }
        }
        if !probeForValidity(root: left, end: end, errPath: &errPath) {
            errPath.append(root)
            return false
        }
        if !probeForValidity(root: right, end: end, errPath: &errPath) {
            errPath.append(root)
            return false
        }
        return true
    }
    func dumpHeap(){
        print(_h)
    }
    func buildHeapPath(_ i:Int)->[T]{
        var r = [T]()
        var index = i
        while true{
            r.append(_h[index])
            if index == 0 {break}
            index = (index-1)/2
        }
        return r
    }
    func dumpHeapPaths(){
        var paths = [[T]]()
        for i in (_h.count-1)/2..<_h.count{
            paths.append(buildHeapPath(i).reversed())
        }
        for p in paths{
            print(p)
        }
    }

}
