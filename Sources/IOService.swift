import Foundation

typealias Message = String
typealias Amount = Double
typealias InterestRate = Double

struct IOService {
    
    enum OutputType {
        case error(error: ArgumentInputError)
        case standard(message: Message)
    }
    
    enum ArgumentInputError: Error {
        case wrongArgument(input: String)
        
        var localizedDescription: String {
            switch self {
            case .wrongArgument(input: let message):
                return "Wrong argument format:\(message), example: \"150 usd eur 5.0\" or \"150 usd eur\""
            }
        }
    }
    
    private enum Instruction {
        static let title = "\nThese are common ExRateCal commands used in various situations:\n"
        static let usage = """
                           usage:       ./ExRateCalc 150.0 usd eur 5.0
                           description: ./ExRateCalc 'amount', 'initial currency', 'result currency', 'interest rate this property is optional with a 0.0 default value'
                           available currencies: usd, eur \n
                           """
    }
    
    static let shared = IOService()
    private init() {}
    
    func write(_ output: OutputType) {
        switch output {
        case .standard(let message):
            Logger.log(.debug(info: message))
        case .error(let error):
            Logger.log(.error(info: error.localizedDescription))
            printUsage()
        }
    }
    
    private func printUsage() {
        Logger.log(.instruction(info: Instruction.title))
        Logger.log(.instruction(info: Instruction.usage))
    }
    
    func readArguments() throws -> (amount: Amount, baseCurrency: Currency, convertedCurrency: Currency, interestRate: Double) {
        let input = CommandLine.arguments
            .enumerated()
            .filter{ $0.offset > 0 }
            .map{ $0.element }
            .reduce("", {$0 + " " + $1})
        
        if CommandLine.arguments.count == 4 {
            guard let amount = Amount(CommandLine.arguments[1]),
                let baseCurrency = Currency(rawValue: CommandLine.arguments[2]),
                let convertedCurrency = Currency(rawValue: CommandLine.arguments[3]) else {
                throw ArgumentInputError.wrongArgument(input: input)
            }
            
            return (amount: amount, baseCurrency: baseCurrency, convertedCurrency: convertedCurrency, interestRate: .zero)
        } else if CommandLine.arguments.count == 5 {
            guard let amount = Amount(CommandLine.arguments[1]),
                let baseCurrency = Currency(rawValue: CommandLine.arguments[2]),
                let convertedCurrency = Currency(rawValue: CommandLine.arguments[3]),
                let interestRate = Double(CommandLine.arguments[4]) else {
                throw ArgumentInputError.wrongArgument(input: input)
            }
            
            return (amount: amount, baseCurrency: baseCurrency, convertedCurrency: convertedCurrency, interestRate: interestRate)
        }
        
        throw ArgumentInputError.wrongArgument(input: input)
    }
}
