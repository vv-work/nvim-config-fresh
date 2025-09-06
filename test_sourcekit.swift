import Foundation

struct Greeter {
    let name: String
    func greet() {
        print("Hello, \(name)!")
    }
}

let g = Greeter(name: "Swift")
g.greet()

