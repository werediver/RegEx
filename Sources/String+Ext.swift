import Foundation

extension String {
    func range(_ nsRange : NSRange) -> Range<String.Index>? {
        let utf16start = utf16.startIndex.advanced(by: nsRange.location)
        let utf16end = utf16start.advanced(by: nsRange.length)
        if let start = utf16start.samePosition(in: self), let end = utf16end.samePosition(in: self) {
            return start ..< end
        } else {
            return nil
        }
    }

    func nsRange(_ range: Range<String.Index>) -> NSRange {
        let utf16start = range.lowerBound.samePosition(in: utf16)
        let utf16end   = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.startIndex.distance(to: utf16start), length: utf16start.distance(to: utf16end))
    }
}
