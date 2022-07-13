//
//  String+.swift
//  onBoardingTask
//
//  Created by pineone on 2022/07/13.
//

import Foundation

extension String{
    func calculateToDaller() -> String {
        let won : Double = 1300.00 // 1달러당 환율
        var dallor =  self
        
        let numFormatter =  NumberFormatter()
        numFormatter.numberStyle = .decimal // 천원 절삭단위
        
        dallor.remove(at: dallor.startIndex) //
        let stringToDouble =  Double(dallor)!
        let result:Double = Double(stringToDouble) * won
        return numFormatter.string(from: NSNumber(value: result))!
    }
}
