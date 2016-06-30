//
//  Molecule.swift
//  NMR Spectra
//
//  Created by Alican Toprak on 27.06.16.
//  Copyright © 2016 Alican Toprak. All rights reserved.
//

import Foundation
import CoreGraphics
import Charts

struct Coupling{
    let boundaries:CGRect
    let ranges:(Int, Int)
}


class Molecule{
    
    let name: String
    let drawable: String
    let couplings:[Coupling]
    let ppm: [String]
    let signal: [ChartDataEntry]
    
    init(name: String, couplings:[Coupling], ppm: [String], signal: [ChartDataEntry]){
        self.name = name
        self.drawable = name
        self.couplings = couplings
        self.ppm = ppm
        self.signal = signal
    }
    
    
    
    func getCouplingForPosition(point:CGPoint)-> Int?{
        
        for (index, c) in couplings.enumerate(){
            if CGRectContainsPoint(c.boundaries, point){
             return index
            }
        }
        return nil
    }
}