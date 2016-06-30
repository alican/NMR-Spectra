//
//  NMRDataSource.swift
//  NMR Spectra
//
//  Created by Alican Toprak on 16.06.16.
//  Copyright © 2016 Alican Toprak. All rights reserved.
//

import Foundation
import Charts
import SwiftCSV

let DATA: [String:[Coupling]] = [
    "EthylAcetate":[
        Coupling(boundaries: CGRect(x: 0, y: 0, width: 70, height: 90), ranges:(10000, 11500)),
        Coupling(boundaries: CGRect(x: 130, y: 30, width: 30, height: 90), ranges:(7000, 9000)),
        Coupling(boundaries: CGRect(x: 160, y: 30, width: 70, height: 90), ranges:(11501, 13000))
    ],
    "EthylAcetate2":[
        Coupling(boundaries: CGRect(x: 0, y: 0, width: 70, height: 90), ranges:(10000, 11500)),
        Coupling(boundaries: CGRect(x: 130, y: 30, width: 30, height: 90), ranges:(7000, 9000)),
        Coupling(boundaries: CGRect(x: 160, y: 30, width: 70, height: 90), ranges:(11501, 13000))
    ]
    
]


let MOLDATA: [String] = ["EthylAcetate", "EthylAcetate2"]

var Cache:[String:Molecule] = [:]


class NMRDataSource{
    
 
    
    func getMolecule(name: String) -> Molecule?{
        
        if Cache[name] != nil{
            return Cache[name]
        }
        
        do{
            let csvURL = NSBundle(forClass: NMRDataSource.self).URLForResource(name, withExtension: "csv")!
            let csv = try CSV(url: csvURL)
            
            var dataEntries: [ChartDataEntry] = []
            
            for (index, element) in csv.rows.reverse().enumerate() {
                let signal =  Double(element["Col2"]!)
                dataEntries.append(ChartDataEntry(value: signal!, xIndex: index))
            }
            
            let first:Double = round(Double(csv.columns["Col1"]!.first!)!)
            let last:Double = round(Double(csv.columns["Col1"]!.last!)!)
            
            var xVLabel:[String] = []
            
            
            for a in Array(first.stride(to: last, by: 0.5)){
                xVLabel.append(String(format:"%.1f", a))
            }
            let molecule = Molecule(name: name, couplings: DATA[name]!, ppm: csv.columns["Col1"]!.reverse(), signal: dataEntries)
            Cache[name] = molecule
            return molecule
            
            
        }catch{
            
        }

        return nil
    }
    
    




}