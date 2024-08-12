// Copyright (c) 2019 Hèctor Marquès Ranea
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
import XCTest
@testable import Permissions

final class ArrayRemovingTests: XCTestCase {
    func testRemovingLastFromEmptyArray() {
        XCTAssertEqual([Int]().removingLast(), [Int]())
    }

    func testRemovingLastFromOneElementArray() {
        XCTAssertEqual([0].removingLast(), [])
    }

    func testRemovingLastFromManyElementsArray() {
        XCTAssertEqual(["m", "a", "n", "y"].removingLast(), ["m", "a", "n"])
    }

    func testRemovingFirstFromEmptyArray() {
        XCTAssertEqual([Int]().removingFirst(), [Int]())
    }

    func testRemovingFirstFromOneElementArray() {
        XCTAssertEqual([0].removingFirst(), [])
    }

    func testRemovingFirstFromManyElementsArray() {
        XCTAssertEqual(["m", "a", "n", "y"].removingFirst(), ["a", "n", "y"])
    }

    func testRemoving() {
        XCTAssertEqual(["m", "a", "n", "y"].removing("n"), ["m", "a", "y"])
    }

    func testRemovingDuplicates() {
        XCTAssertEqual(["a", "a", "b", "c", "b", "a"].removingDuplicates(), ["a", "b", "c"])
    }
}

