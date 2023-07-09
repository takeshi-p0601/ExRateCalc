import Foundation

enum Logger {
    case error(info: String)
    case debug(info: String)
    case instruction(info: String)
    
    private enum ANSIColor {
        static let red = "\u{001B}[0;31m"
        static let green = "\u{001B}[0;32m"
        static let blue = "\u{001B}[0;33m"
        static let `default` = "\u{001B}[0;0m"
    }
    
    static func log(_ state: Logger) {
        switch state {
        case .error(info: let info):
            printError(info)
        case .debug(info: let info):
            printDebug(info)
        case .instruction(info: let info):
            printInstruction(info)
        }
    }
    
    private static func printError(_ info: String) {
        print("\(ANSIColor.red)\(Date())\nError: - \(info)\(ANSIColor.default)")
    }
    
    private static func printDebug(_ info: String) {
        print("\(ANSIColor.green)\(Date())\nSuccess: - \(info)\(ANSIColor.default)")
    }
    
    private static func printInstruction(_ info: String) {
        print("\(ANSIColor.blue)\n\(info)\(ANSIColor.default)")
    }
}
