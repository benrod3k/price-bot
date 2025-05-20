struct PriceResponse: Codable {
    let tickers: [Ticker]
}

struct Ticker: Codable {
    let base: String
    let target: String
    let last: Double
    let volume: Double
    let timestamp: String
    let market: Market
}

struct Market: Codable {
    let name: String
    let identifier: String
    let has_trading_incentive: Bool
}