//
//  NewBookFlow.swift
//  onBoardingTask
//
//  Created by pineone on 2022/08/17.
//

import Foundation
import RxFlow

class NewBookFlow:Flow{
    var root: Presentable{
        rootViewController.topViewController?.title = "New Books"
        rootViewController.navigationBar.prefersLargeTitles = true

        return self.rootViewController
    }
    
    let rootViewController =  UINavigationController(rootViewController: NewBookViewController())
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step  =  step as? MainStep else { return .none }
        
        switch step {
        case .Detail:
            return goToDetail()
        default :
            return .none
        }
    }
    
    func goToDetail() -> FlowContributors{
        print("디테일로 간다")
        return .none
    }
    
}
