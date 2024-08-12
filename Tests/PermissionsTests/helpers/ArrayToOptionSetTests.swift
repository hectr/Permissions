// Copyright (c) 2020 Hèctor Marquès Ranea
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

final class ArrayToOptionSetTests: XCTestCase {
    struct AnyOptionSet: OptionSet, Equatable {
        static var allCases: [AnyOptionSet] {
            [.a, .b, .c]
        }

        static let a = AnyOptionSet(rawValue: 1 << 0)
        static let b = AnyOptionSet(rawValue: 1 << 1)
        static let c = AnyOptionSet(rawValue: 1 << 2)

        let rawValue: Int

        init(rawValue: Int) {
            guard rawValue == 0
                || rawValue & (1 << 0) == (1 << 0)
                || rawValue & (1 << 1) == (1 << 1)
                || rawValue & (1 << 2) == (1 << 2) else {
                fatalError()
            }
            self.rawValue = rawValue
        }
    }

    func testToOptionSet() {
        let array: [AnyOptionSet] = [.b, .c]
        let result = array.toOptionSet()
        let expected = AnyOptionSet.c.union(.b)
        XCTAssertEqual(expected, result)
    }
}

