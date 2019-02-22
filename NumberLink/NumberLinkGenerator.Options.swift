extension NumberLinkGenerator {
    public struct Options {
        public var limit: Int
        public var isVerbose: Bool

        public static let `default` = Options(
            limit: 100,
            isVerbose: false
        )
    }
}
