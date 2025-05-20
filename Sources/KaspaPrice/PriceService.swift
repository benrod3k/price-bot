class PriceService {
    private var timer: Timer?

    func fetchPrice() {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/kaspa/tickers?exchange_ids=gate")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                Logger.logError("Error fetching price: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                Logger.logError("No data received")
                return
            }

            do {
                let priceResponse = try JSONDecoder().decode(PriceResponse.self, from: data)
                if let ticker = priceResponse.tickers.first {
                    print("Kaspa Price: \(ticker.last)")
                } else {
                    Logger.logError("No tickers found in response")
                }
            } catch {
                Logger.logError("Error decoding response: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func schedulePriceFetch(interval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.fetchPrice()
        }
    }

    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
}