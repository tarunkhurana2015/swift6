import UIKit

// Simple Closure
let clos1 = {() -> Void in
    print("Hello World")
}

clos1()

// single parameter
let clos2 = {(name: String) -> Void in
    print("Hello \(name)")
}

clos2("John")

// pass closure in a function
func testClosure(handler: (String) -> Void) {
    handler("Luna")
}
testClosure(handler: clos2)

// return a value from the closure
let clos3 = {
    (name: String) -> String in
    return "Hello \(name)"
}
var message = clos3("Maple")
print(message)

// shorthand syntax for closures
func testFunction(num: Int, handler: () -> Void) {
    for _ in 0..<num {
        handler()
    }
}
let clos = { () -> Void in
    print("Hello from standard syntax")
}
testFunction(num: 10, handler: clos)
testFunction(num: 4, handler: { print("Hello from the shorthand syntax")})

// with paremater
func testFunction2(num: Int, handler: (_ : String) -> Void) {
    for _ in 0..<num {
        handler("Me")
    }
}
testFunction2(num: 5, handler: clos2)

testFunction2(num: 5) {
    print("Hello from \($0)")
}

let clos5: (String, String) -> Void = {
    print("\($0) \($1)")
}
clos5("Hello", "World")

let clos6: () -> () = {
    print("Howdy")
}
clos6()

// without the retrun keyword
let cols7 = { (first: Int, second: Int) -> Int in first + second}
print(cols7(5,5))

// map
let guests = ["Jon", "Heidi", "Kailey", "Kai"]
var mappedGuests = guests.map {
    return "Welcome \($0)"
}
print(mappedGuests)

// reuse map closures
let greetGuest = { (name: String) -> Void in
    print("Hello guest named \(name)")
}
let sayGoodbye = { (name: String) -> Void in
    print("Goodbye \(name)")
}
guests.map(greetGuest)
guests.map(sayGoodbye)


//
func analyzeTemperature(analysis: ([Int]) -> Void) {
    let tempArray = [72, 74, 76, 68, 70, 72, 66]
    analysis(tempArray)
}

let threashhold = 71
let daysAboveThreashhold: ([Int]) -> Void = {
    temperatures in
    var aboveThreashholdCount = 0
    for temp in temperatures {
        if temp > threashhold {
            aboveThreashholdCount += 1
        }
    }
    print("Number of days above threashhold: \(aboveThreashholdCount)")
}
analyzeTemperature(analysis: daysAboveThreashhold)

// Adavnced Closures

enum LogLevel {
    case info, warning, error
}
class Logger {
    typealias LogLevelHandler = (String) -> Void
    
    private var handlesrs: [LogLevel: [LogLevelHandler]] = [:]
    
    func registerHandler(for level: LogLevel, handler: @escaping LogLevelHandler) {
        if handlesrs[level] == nil {
            handlesrs[level] = []
        }
        handlesrs[level]?.append(handler)
    }
    
    func log(_ message: String, level: LogLevel) {
        if let levelHandlers = handlesrs[level] {
            for handler in levelHandlers {
                handler(message)
            }
        }
    }
}

let logger = Logger()

logger.registerHandler(for: .info) { message in
    print("Info: \(message)")
}
logger.registerHandler(for: .warning) { message in
    print("Warning: \(message)")
}
logger.registerHandler(for: .error) { message in
    print("Error: \(message)")
}

logger.log("info message", level: .info)
logger.log("warning message", level: .warning)
logger.log("error message", level: .error)

// Result builders

@resultBuilder
struct StringBuilder {
    static func buildBlock(_ components: String...) -> String {
        return components.joined()
    }
}
func buildString(@StringBuilder _ components: () -> String) -> String {
    return components()
}

let results = buildString {
    "Hello, "
    "Mastering "
    "Swift!"
}
print("\(results)")

// JSON to dictionary
struct DictionaryComponent {
    let dictionary: [String: Any]
    
    func addToJSON(_ json: inout [String: Any]) {
        for (key, value) in dictionary {
            json[key] = value
        }
    }
}

@resultBuilder
struct JSONBuilder {
    static func buildBlock(_ components: DictionaryComponent...) -> [String: Any] {
        var json: [String: Any] = [:]
        for component in components {
            component.addToJSON(&json)
        }
        return json
    }
    
    static func buildExpression(_ expression: [String: Any]) -> DictionaryComponent {
        return DictionaryComponent(dictionary: expression)
    }
}

@JSONBuilder
func buildJSON() -> [String: Any] {
    [
        "name": "Jon",
        "age": 30,
        "address": [
                "city": "Boston",
                "zipcode": "10001"
        ]
    ]
}
let json = buildJSON()
print(json)
