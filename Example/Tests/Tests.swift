import XCTest
import LoadableResult

enum TestError: Error {
    case error1
    case error2
}

class Tests: XCTestCase {
    
    func testMap() {
        let stringResult = LoadableResult<String>.loaded("5")
        let mapped: Bool = stringResult.map { result in return true }
        XCTAssertTrue(mapped)
    }

    func testMapLoaded_loaded() {
        let stringResult = LoadableResult<String>.loaded("5")
        let intResult = stringResult.mapLoaded { (Int($0) ?? -1) }

        XCTAssertEqual(intResult, .loaded(5))
    }

    func testMapLoaded_inactive() {
        let stringResult = LoadableResult<String>.inactive
        let intResult = stringResult.mapLoaded { (Int($0) ?? -1) }

        XCTAssertEqual(intResult, .inactive)
    }

    func testMapLoaded_loading() {
        let stringResult = LoadableResult<String>.loading
        let intResult = stringResult.mapLoaded { (Int($0) ?? -1) }

        XCTAssertEqual(intResult, .loading)
    }

    func testMapLoaded_error() {
        let stringResult = LoadableResult<String>.error(TestError.error1)
        let intResult = stringResult.mapLoaded { (Int($0) ?? -1) }

        XCTAssertEqual(intResult, .error(TestError.error1))
    }

    func testMapLoaded_loaded_failable_success() {
        let stringResult = LoadableResult<String>.loaded("5")
        
        let intResult = stringResult.mapLoaded { stringValue -> Result<Int, Error> in
            if let intValue = Int(stringValue) {
                return .success(intValue)
            } else {
                return .failure(TestError.error1)
            }
        }

        XCTAssertEqual(intResult, .loaded(5))
    }

    func testMapLoaded_loaded_failable_failure() {
        let stringResult = LoadableResult<String>.loaded("a")
        let intResult = stringResult.mapLoaded { stringValue -> Result<Int, Error> in
            if let intValue = Int(stringValue) {
                return .success(intValue)
            } else {
                return .failure(TestError.error1)
            }
        }

        XCTAssertEqual(intResult, .error(TestError.error1))
    }

    func testMapLoaded_loaded_predictable_failable_success() {
        let stringResult = LoadableResult<String>.loaded("5")

        let intResult = stringResult
            .mapLoaded(onFailure: TestError.error1) { Int($0) }

        XCTAssertEqual(intResult, .loaded(5))
    }

    func testMapLoaded_loaded_predictable_failable_failure() {
        let stringResult = LoadableResult<String>.loaded("a")
        let intResult = stringResult
            .mapLoaded(onFailure: TestError.error1) { Int($0) }

        XCTAssertEqual(intResult, .error(TestError.error1))
    }

    func testMapLoaded_loaded_withFallback_success() {
        let stringResult = LoadableResult<String>.loaded("5")

        let intResult = stringResult
            .mapLoaded(onFailure: -1) { Int($0) }

        XCTAssertEqual(intResult, .loaded(5))
    }

    func testMapLoaded_loaded_withFallback_failure() {
        let stringResult = LoadableResult<String>.loaded("a")
        let intResult = stringResult.mapLoaded(onFailure: -1) { Int($0) }

        XCTAssertEqual(intResult, .loaded(-1))
    }

}
