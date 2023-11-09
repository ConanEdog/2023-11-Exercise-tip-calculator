//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by 方奎元 on 2023/11/6.
//

import Foundation
import Combine

class CalculatorVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
        let resetCalculatorPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let audioPlayerService: AudioPlayerService
    //dependency injection -> when initialize the VM, have to pass in the service that is dependent on.
    init(audioPlayerService: AudioPlayerService = DefaultAudioPlayer()) {
        self.audioPlayerService = audioPlayerService
    }
    
    func transform(input: Input) -> Output {
        
//        input.splitPublisher.sink { split in
//            print("the split: \(split)")
//        }.store(in: &cancellables)
        
        //CombineLatest: use to obeserve if any of these publisher change.
        //flatMap: transform updateViewPublisher into a type of AnyPublisher<Result, Never>
        let updateViewPublisher = Publishers.CombineLatest3(input.billPublisher, input.tipPublisher, input.splitPublisher).flatMap { [unowned self] (bill, tip, split) in
            let totalTip = getTipAmount(bill: bill, tip: tip)
            let totalBill = bill + totalTip
            let amountPerPerson = totalBill / Double(split)
            let result = Result(amountPerPerson: amountPerPerson, totalBill: totalBill, totalTip: totalTip)
            
            return Just(result)
        }.eraseToAnyPublisher()
        
        let resetCalculatorPublisher = input.logoViewTapPublisher.handleEvents(receiveOutput: { [unowned self] in
            audioPlayerService.playSound()
        }).flatMap {
            return Just($0)     // = Just(())
        }.eraseToAnyPublisher()
        
        return Output(updateViewPublisher: updateViewPublisher, resetCalculatorPublisher: resetCalculatorPublisher)
    }
    
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
            
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(value: let value):
            return Double(value)
        }
    }
    
}
