import Foundation

internal extension String {

    var fullRange: Range<String.Index> { return startIndex ..< endIndex }

    func range(_ nsRange : NSRange) -> Range<String.Index>? {
        if  let utf16start = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let utf16end = utf16.index(utf16start, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let start = String.Index(utf16start, within: self),
            let end   = String.Index(utf16end,   within: self)
        {
            return start ..< end
        } else {
            return nil
        }
    }

    func nsRange(_ range: Range<String.Index>) -> NSRange {
        let utf16start = String.UTF16View.Index(range.lowerBound, within: utf16)
        let utf16end   = String.UTF16View.Index(range.upperBound, within: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: utf16start), length: utf16.distance(from: utf16start, to: utf16end))
    }

}
