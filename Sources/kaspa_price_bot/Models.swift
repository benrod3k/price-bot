import Foundation

struct KaspaTickerResponse: Codable {
    let tickers: [Ticker]
}

struct Ticker: Codable {
    let base: String
    let target: String
    let last: Double
    let volume: Double
    let timestamp: String
}