import XCTest

final class CatalogUITests: XCTestCase {
  func testSystemFolder() throws {
    continueAfterFailure = false
    let config = try Data(contentsOf: URL(fileURLWithPath: #"__CONFIG__"#))
    let env = try JSONDecoder().decode([String:String].self, from: config)
    let app = XCUIApplication()
    app.launchEnvironment = env
    app.launch()
    let button = app.buttons["Space CI Select"].firstMatch
    XCTAssertTrue(button.waitForExistence(timeout: 90), app.debugDescription)
    let finder = XCUIApplication(bundleIdentifier: "com.apple.finder")
    finder.activate()
    XCTAssertTrue(finder.wait(for: .runningForeground, timeout: 10))
    app.activate()
    XCTAssertTrue(button.isHittable, app.debugDescription)
    button.click()
    XCTAssertTrue(app.wait(for: .notRunning, timeout: 100))
    XCTAssertTrue(FileManager.default.fileExists(atPath: env["CATALOG_DRILL"]! + "/report.json"))
  }
}
