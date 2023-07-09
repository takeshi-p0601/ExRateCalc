import Foundation

protocol ExRateError: Error, CustomStringConvertible {
    var description: String {get}
}

enum ArgumentInputError: ExRateError {
    case wrongArgument(input: String)
    
    var description: String {
        switch self {
        case .wrongArgument(input: let message):
            return "Wrong argument format: \(message), example: \"150 usd eur 5.0\" or \"150 usd eur\""
        }
    }
}

enum InputError: ExRateError {
    case wrongAmount(input: String)
    case wrongBaseCurrency(input: String)
    case wrongConvertedCurrency(input: String)
    case wrongInterestRate(input: String)
    case wrongInput
    
    var description: String {
        let availableCurrencies = "Available currencies: usd, eur"
        switch self {
        case .wrongAmount(input: let input):
            return "Wrong input: \(input), example: \"150.0\""
        case .wrongBaseCurrency(input: let input):
            return "Wrong input: \(input), example: \"usd\"\n\(availableCurrencies)"
        case .wrongConvertedCurrency(input: let input):
            return "Wrong input: \(input), example: \"usd\"\n\(availableCurrencies)"
        case .wrongInterestRate(input: let input):
            return "Wrong input: \(input), example: \"5.0\"\nDefault value is 0.0"
        case .wrongInput:
            return "Unidentified error"
        }
    }
}

enum ProgrammedExit: ExRateError {
    case exit
    
    var description: String {
        return "Exit"
    }
}
