//  Collection+Extensions.swift
//
// Copyright (c) 11/10/14 Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

extension Collection where Self.Index == Self.Indices.Iterator.Element {
    /**
     Returns an optional element. If the `index` does not exist in the collection, the subscript returns nil.

     - parameter safe: The index of the element to return, if it exists.

     - returns: An optional element from the collection at the specified index.
     */
    public subscript(safe i: Index) -> Self.Iterator.Element? {
        return at(i)
    }

    /**
     Returns an optional element. If the `index` does not exist in the collection, the function returns nil.

     - parameter index: The index of the element to return, if it exists.

     - returns: An optional element from the collection at the specified index.
     */
    public func at(_ i: Index) -> Self.Iterator.Element? {
        return indices.contains(i) ? self[i] : nil
    }
}
