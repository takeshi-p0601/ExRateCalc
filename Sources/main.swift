import Foundation

func calculate(_ amount: Amount,
               _ interestRate: InterestRate,
               from baseCurrency: Currency,
               to convertedCurrency: Currency) {
    
    let calc = Calculator(interestRate: interestRate)
    let exchangedAmount = calc.convert(amount: amount,
                                       from: baseCurrency,
                                       to: convertedCurrency)
    IOService.shared.write(.standard(message: Message(format:"%.2f", exchangedAmount)))
}

func launchProgram() throws {
    var programState = ProgramState.start
    var amount: Amount!
    var baseCurrency: Currency!
    var convertedCurrency: Currency!
    var interestRate: InterestRate!
    
    while programState != .exit {
        do {
            programState.printInstruction()
            switch programState {
            case .start:
                if let args: IOService.Arguments = try IOService.shared.readArguments() {
                    calculate(args.amount, args.interestRate, from: args.baseCurrency, to: args.convertedCurrency)
                }
                programState = .introduction
            case .introduction:
                programState = try IOService.shared.readInput(.introduction)
            case .insertAmount:
                amount = try IOService.shared.readInput(.insertAmount)
                programState = .chooseBaseCurrency
            case .chooseBaseCurrency:
                baseCurrency = try IOService.shared.readInput(.chooseBaseCurrency)
                programState = .chooseConvertedCurrency
            case .chooseConvertedCurrency:
                convertedCurrency = try IOService.shared.readInput(.chooseConvertedCurrency)
                programState = .insertInterestRate
            case .insertInterestRate:
                interestRate = try IOService.shared.readInput(.insertInterestRate)
                programState = .calculate
            case .calculate:
                calculate(amount, interestRate, from: baseCurrency, to: convertedCurrency)
                programState = .introduction
            case .exit:
                exit(EXIT_SUCCESS)
            }
        } catch let error as ArgumentInputError {
            IOService.shared.write(.error(error: error))
            programState = .introduction
        } catch let error as InputError {
            IOService.shared.write(.error(error: error))
            switch error {
            case .wrongAmount:
                programState = .insertAmount
            case .wrongBaseCurrency:
                programState = .chooseBaseCurrency
            case .wrongConvertedCurrency:
                programState = .chooseConvertedCurrency
            case .wrongInterestRate:
                programState = .insertInterestRate
            case .wrongInput:
                programState = .introduction
            }
        } catch let error as ProgrammedExit {
            IOService.shared.write(.error(error: error))
            programState = .exit
        }
    }
}

do {
    try launchProgram()
} catch let error as ExRateError {
    IOService.shared.write(.error(error: error))
}
