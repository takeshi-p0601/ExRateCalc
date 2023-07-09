import Foundation

typealias Message = String
typealias Amount = Double
typealias InterestRate = Double

struct IOService {
    
    struct Arguments {
        let amount: Amount
        let baseCurrency: Currency
        let convertedCurrency: Currency
        let interestRate: InterestRate
    }
    
    enum OutputType {
        case error(error: ExRateError)
        case standard(message: Message)
    }
    
    private enum Instruction {
        static let title = "\nThese are common ExRateCal commands used in various situations:\n"
        static let usage = """
                           usage:       ./ExRateCalc 150.0 usd eur 5.0
                           description: ./ExRateCalc 'amount', 'initial currency', 'result currency', 'interest rate this property is optional with a 0.0 default value'
                           available currencies: usd, eur \n
                           """
    }
    
    private enum ProgramStartType {
        static let withoutArgument = 1
        static let withHelp = 2
        static let withoutInterestRate = 4
        static let withInterestRate = 5
    }
    
    private enum CommonInputs {
        static let help = "--help"
        static let shortHelp = "-h"
        static let newTransaction = "new"
        static let exit = "exit"
    }
    
    static let shared = IOService()
    private init() {}
    
    func write(_ output: OutputType) {
        switch output {
        case .standard(let message):
            Logger.log(.debug(info: message))
        case .error(let error):
            Logger.log(.error(info: error.description))
        }
    }
    
    private func printUsage() {
        Logger.log(.instruction(info: Instruction.title))
        Logger.log(.instruction(info: Instruction.usage))
    }
    
    func readArguments<T>() throws -> T? {
        let input = CommandLine.arguments
            .enumerated()
            .filter{ $0.offset > 0 }
            .map{ $0.element }
            .reduce("", {$0 + " " + $1})
        
        switch CommandLine.arguments.count {
        case ProgramStartType.withoutArgument:
            return nil
        case ProgramStartType.withHelp:
            if CommandLine.arguments[1] == CommonInputs.shortHelp || CommandLine.arguments[1] == CommonInputs.help {
                printUsage()
                throw ProgrammedExit.exit
            }
            
            throw ArgumentInputError.wrongArgument(input: input)
        case ProgramStartType.withoutInterestRate:
            guard let amount = Amount(CommandLine.arguments[1]),
                let baseCurrency = Currency(rawValue: CommandLine.arguments[2]),
                let convertedCurrency = Currency(rawValue: CommandLine.arguments[3]) else {
                throw ArgumentInputError.wrongArgument(input: input)
            }
            
            return Arguments(amount: amount,
                        baseCurrency: baseCurrency,
                        convertedCurrency: convertedCurrency,
                        interestRate: .zero) as? T
        case ProgramStartType.withInterestRate:
            guard let amount = Amount(CommandLine.arguments[1]),
                let baseCurrency = Currency(rawValue: CommandLine.arguments[2]),
                let convertedCurrency = Currency(rawValue: CommandLine.arguments[3]),
                let interestRate = InterestRate(CommandLine.arguments[4]) else {
                throw ArgumentInputError.wrongArgument(input: input)
            }
            
            return Arguments(amount: amount,
                        baseCurrency: baseCurrency,
                        convertedCurrency: convertedCurrency,
                        interestRate: interestRate) as? T
        default:
            throw ArgumentInputError.wrongArgument(input: input)
        }
    }
    
    func readInput<T>(_ programState: ProgramState) throws -> T {
        guard let input = readLine() else {throw InputError.wrongInput}
        if input == CommonInputs.exit {
            throw ProgrammedExit.exit
        }
        
        switch programState {
        case .introduction:
            if input == CommonInputs.newTransaction {
                return ProgramState.insertAmount as! T
            } else if input == CommonInputs.exit {
                return ProgramState.exit as! T
            } else {
                throw InputError.wrongInput
            }
        case .insertAmount:
            if let amount = Amount(input), amount is T {
                return amount as! T
            } else {
                throw InputError.wrongAmount(input: input)
            }
        case .chooseBaseCurrency:
            if let currency = Currency(rawValue: input), currency is T {
                return currency as! T
            } else {
                throw InputError.wrongBaseCurrency(input: input)
            }
        case .chooseConvertedCurrency:
            if let currency = Currency(rawValue: input), currency is T {
                return currency as! T
            } else {
                throw InputError.wrongConvertedCurrency(input: input)
            }
        case .insertInterestRate:
            if input.isEmpty {
                return InterestRate(0.0) as! T
            }
            
            if let rate = InterestRate(input), rate is T {
                return rate as! T
            } else {
                throw InputError.wrongInterestRate(input: input)
            }
        default:
            throw InputError.wrongInput
        }
    }
}
