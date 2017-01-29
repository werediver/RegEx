import Foundation

public struct RegEx {
    public let regex: NSRegularExpression

    public init(_ pattern: String, options: NSRegularExpression.Options = []) {
        regex = try! NSRegularExpression(pattern: pattern, options: options)
    }

    public func enumerateMatches(in s: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil, body: (Result?, NSRegularExpression.MatchingFlags) -> Bool) {
        let nsRange = s.nsRange(range ?? s.startIndex ..< s.endIndex)
        regex.enumerateMatches(in: s, options: options, range: nsRange) { textCheckingResult, flags, stop in
            if textCheckingResult.flatMap({ body(Result(src: s, textCheckingResult: $0), flags) }) ?? false {
                stop.pointee = true
            }
        }
    }

    public func matches(in s: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> [Result] {
        let nsRange = s.nsRange(range ?? s.startIndex ..< s.endIndex)
        return regex.matches(in: s, options: options, range: nsRange).map { Result(src: s, textCheckingResult: $0) }
    }

    public func numberOfMatches(in s: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Int {
        let nsRange = s.nsRange(range ?? s.startIndex ..< s.endIndex)
        return regex.numberOfMatches(in: s, options: options, range: nsRange)
    }

    public func firstMatch(in s: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Result? {
        let nsRange = s.nsRange(range ?? s.startIndex ..< s.endIndex)
        return regex.firstMatch(in: s, options: options, range: nsRange).flatMap { Result(src: s, textCheckingResult: $0) }
    }

    public func rangeOfFirstMatch(in s: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Range<String.Index>? {
        let nsRange = s.nsRange(range ?? s.startIndex ..< s.endIndex)
        return s.range(regex.rangeOfFirstMatch(in: s, options: options, range: nsRange))
    }


    public func stringByReplacingMatches(in s: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil, template: String) -> String {
        let nsRange = s.nsRange(range ?? s.startIndex ..< s.endIndex)
        return regex.stringByReplacingMatches(in: s, options: options, range: nsRange, withTemplate: template)
    }

    public func replaceMatches(in s: inout String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil, template: String) -> Int {
        var n = 0
        enumerateMatches(in: s) { match, flags -> Bool in
            if let match = match,
               let range = match.ranges.first
            {
                s.replaceSubrange(range, with: template)
                n += 1
            }
            return false
        }
        return n
    }

    public struct Result {
        public let textCheckingResult: NSTextCheckingResult
        public let ranges: [Range<String.Index>]
        public let texts: [String]

        public init(src: String, textCheckingResult: NSTextCheckingResult) {
            self.textCheckingResult = textCheckingResult
            ranges = (0 ..< textCheckingResult.numberOfRanges).flatMap { src.range(textCheckingResult.rangeAt($0)) }
            texts = ranges.map { src[$0] }
        }
    }
}

extension RegEx: Equatable {
    public static func ==(a: RegEx, b: RegEx) -> Bool {
        return a.regex == b.regex
    }

    public static func ~=(pattern: RegEx, value: String) -> Bool {
        return pattern.firstMatch(in: value) != nil
    }
}

extension RegEx: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
}
