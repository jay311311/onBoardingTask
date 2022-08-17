//
//  AppStepper.swift
//  onBoardingTask
//
//  Created by pineone on 2022/08/17.
//

import Foundation
import RxCocoa
import RxFlow
//stepper :  Flow내부에서 Step을 방출할수 있는 모든 것
class AppStepper : Stepper {
    static let shared  = AppStepper()
    
    var steps: PublishRelay<Step> =  PublishRelay<Step>()
    
    var initialStep: Step{
        return MainStep.initStep
    }
    
    
}
