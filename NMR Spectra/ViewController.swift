//
//  ViewController.swift
//  NMR Spectra
//
//  Created by Alican Toprak on 14.06.16.
//  Copyright © 2016 Alican Toprak. All rights reserved.
//

import UIKit
import SwiftCSV
import Charts


class ViewController: UIViewController, ChartViewDelegate {
    
    var months: [String]!
    
    @IBOutlet weak var lineChartView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.lineChartView.delegate = self
    
        do{
            let csvURL = NSBundle(forClass: ViewController.self).URLForResource("Data", withExtension: "csv")!
            let csv = try CSV(url: csvURL)
            
            var dataEntries: [ChartDataEntry] = []
            
            for (index, element) in csv.rows.enumerate() {
                let signal =  Double(element["Col2"]!)
                dataEntries.append(ChartDataEntry(value: signal!, xIndex: index))
            }
            
            setChartData(csv.columns["Col1"]!, signal: dataEntries)

        }catch{
        
        }
        
    }
    
    func setChartData(ppm: [String], signal: [ChartDataEntry]) {

        let dataSet: LineChartDataSet = LineChartDataSet(yVals: signal, label: "First Set")
        
        
        dataSet.axisDependency = .Left // Line will correlate with left axis values
        dataSet.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        dataSet.setCircleColor(UIColor.redColor()) // our circle will be dark red
        dataSet.lineWidth = 0.5
        dataSet.circleRadius = 0.0 // the radius of the node circle
        dataSet.fillAlpha = 65 / 255.0
        dataSet.fillColor = UIColor.redColor()
        dataSet.highlightColor = UIColor.whiteColor()
        dataSet.drawCircleHoleEnabled = false
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(dataSet)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: ppm, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        //5 - finally set our data
        self.lineChartView.data = data            
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

