import XCTest
@testable import KaspaPrice

final class PriceServiceTests: XCTestCase {
    
    var priceService: PriceService!

    override func setUp() {
        super.setUp()
        priceService = PriceService()
    }

    override func tearDown() {
        priceService = nil
        super.tearDown()
    }

    func testFetchPrice() {
        let expectation = self.expectation(description: "Fetch price from API")
        
        priceService.fetchPrice { result in
            switch result {
            case .success(let price):
                XCTAssertNotNil(price, "Price should not be nil")
                // Add more assertions based on expected price structure
            case .failure(let error):
                XCTFail("Expected price but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSchedulePriceFetch() {
        let expectation = self.expectation(description: "Schedule price fetch")
        
        priceService.schedulePriceFetch(interval: 1.0) // 1 second interval
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Check if the fetchPrice method was called
            // This could be done by using a mock or a flag
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}