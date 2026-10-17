import Cocoa
import FlutterMacOS
import XCTest
@testable import Space

class RunnerTests: XCTestCase {

  func testTokenValidation() {
    XCTAssertTrue(NotificationActivation.valid(String(repeating: "a", count: 32)))
    for invalid in ["", String(repeating: "a", count: 31),
                    String(repeating: "A", count: 32), String(repeating: "я", count: 32),
                    String(repeating: "1", count: 32) + "?url=https://example.org"] {
      XCTAssertFalse(NotificationActivation.valid(invalid))
    }
  }

  func testPendingActivationBeforeDartReady() {
    let bridge = NotificationActivation()
    let token = String(repeating: "a", count: 32)
    bridge.receive(token)
    bridge.receive("invalid")
    XCTAssertEqual(bridge.start(), token)
    XCTAssertEqual(bridge.start(), "")
  }

  func testLatestPendingActivationWins() {
    let bridge = NotificationActivation()
    bridge.receive(String(repeating: "a", count: 32))
    let latest = String(repeating: "b", count: 32)
    bridge.receive(latest)
    XCTAssertEqual(bridge.start(), latest)
  }

}
