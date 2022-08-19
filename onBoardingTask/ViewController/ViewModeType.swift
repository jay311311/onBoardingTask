//
//  ViewModeType.swift
//  onBoardingTask
//
//  Created by pineone on 2022/08/18.
//

import Foundation
import RxSwift
import RxRelay


protocol ViewModelType {
    
    associatedtype Input
    
    
    associatedtype Output
    
    func trasform(input: Input) -> Output
}
