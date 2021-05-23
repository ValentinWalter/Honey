import XCTest
@testable import Honey

final class HoneyTests: XCTestCase {

//    override class func setUp() {
//        // Simulate having configured Honey with url scheme "test"
//        Honey.config = .init(scheme: "test")
//    }
//
//    func testCreateAction() {
//        // Simulate having run the `Bear.Create` action
//        let uuid = UUID()
//        Honey.runningActions[uuid] = { response in
//            guard case let .success(decoder) = response else { return XCTFail() }
//            guard let output = try? Bear.Create.Output(from: decoder) else { return XCTFail() }
//
//            XCTAssert(output.title == "Test")
//            XCTAssert(output.identifier == "EXAMPLE")
//        }
//
//        // This is what a callback from Bear would look like given the `Bear.Create` action was run
//        let exampleCallback = URL(string: "test://x-callback-url/bear?response=success&response_id=\(uuid.uuidString)&title=Test&identifier=EXAMPLE")!
//
//        // This is what would happen in the AppDelegate
//        XCTAssertNoThrow(try Honey.receive(url: exampleCallback))
//    }
//
//    func testOpenAction() {
//        // Simulate having run the `Bear.OpenNote` action
//        let uuid = UUID()
//        Honey.runningActions[uuid] = { response in
//            guard case let .success(decoder) = response else { return XCTFail() }
//            do {
//                let output = try Bear.OpenNote.Output(from: decoder)
//                XCTAssert(output.title == "EXAMPLE_TITLE")
//                XCTAssert(output.note == "EXAMPLE_TEXT")
//                XCTAssert(output.creationDate.description == "2019-11-19 16:41:08 +0000")
//            }
//            catch { XCTFail(error.localizedDescription) }
//        }
//
//        // This is what a callback from Bear would look like given the `Bear.OpenNote` action was run
//        let exampleCallback = URL(string: "test://x-callback-url/bear?response_id=\(uuid.uuidString)&response=success&creationDate=2019-11-19T16:41:08Z&title=EXAMPLE_TITLE&is_trashed=no&note=EXAMPLE_TEXT&identifier=EXAMPLE_ID&modificationDate=2020-03-22T00:41:22Z&")!
//
//        // This is what would happen in the AppDelegate
//        XCTAssertNoThrow(try Honey.receive(url: exampleCallback))
//    }
//
//    func testInitConfigWithXML() {
//        var xml: String { """
//        <?xml version="1.0" encoding="UTF-8"?>
//        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
//        <plist version="1.0">
//        <dict>
//            <key>CFBundleURLTypes</key>
//            <array>
//                <dict>
//                    <key>CFBundleTypeRole</key>
//                    <string>Editor</string>
//                    <key>CFBundleURLName</key>
//                    <string>example.team.MyApp</string>
//                    <key>CFBundleURLSchemes</key>
//                    <array>
//                        <string>myapp</string>
//                    </array>
//                </dict>
//            </array>
//        </dict>
//        </plist>
//        """
//        }
//        XCTAssertNoThrow(try Honey.Config.from(xml: xml))
//    }
//
//    func testDeleteTag() {
//        // Simulate having run the `Bear.DeleteTag` action
//        // [DeleteTag is one-way only, nothing to simulate]
//
//        // This is what a callback from Bear would look like given the `Bear.DeleteTag` action was run
//        let exampleCallback = URL(string: "test://x-callback-url/bear?response_id=\(UUID())&response=success&")!
//
//        // This is what would happen in the AppDelegate
//        XCTAssertNoThrow(try Honey.receive(url: exampleCallback))
//    }

    static var allTests = [
//        ("testCreateAction", testCreateAction),
//        ("testOpenAction", testOpenAction),
//        ("testInitConfigWithXML", testInitConfigWithXML),
//        ("testDeleteTag", testDeleteTag),
//        ("testFont", testFont),
    ]
}
