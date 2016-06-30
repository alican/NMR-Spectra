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



extension Array {
    func slice(args: Int...) -> Array {
        var s = args[0]
        var e = self.count - 1
        if args.count > 1 { e = args[1] }
        
        if e < 0 {
            e += self.count
        }
        
        if s < 0 {
            s += self.count
        }
        
        let count = (s < e ? e-s : s-e)+1
        let inc = s < e ? 1 : -1
        var ret = Array()
        
        var idx = s
        for _ in 0 ..< count  {
            ret.append(self[idx])
            idx += inc
        }
        return ret
    }
}



class ViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var moleculePlaceholder: UIView!
    var months: [String]!
    var molecule: Molecule!
    var dataSource = NMRDataSource()
    var dataSets : [LineChartDataSet] = [LineChartDataSet]()
    
    var molName : String?
    
    var nightMode:Bool = false
    
    let colors:[UIColor] = [
        UIColor.orangeColor(),
        UIColor.blueColor(),
        UIColor.cyanColor(),
        UIColor.greenColor()
    ]
    
    var molSelection: [Int: (LineChartDataSet, UIView)] = [:]

    
    @IBOutlet weak var lineChartView: LineChartView!


    @IBAction func changeTheme(sender: UIBarButtonItem) {
        print("Theme")
    }
    @IBAction func changeTheme2(sender: UIButton) {
        print("Theme2")
        nightMode = !nightMode
        if (nightMode){
        self.lineChartView.backgroundColor = UIColor.blackColor()
        }else{
        self.lineChartView.backgroundColor = UIColor.whiteColor()
        }
        
    }
    @IBAction func AddMol(sender: UIBarButtonItem) {
        if let mol = dataSource.getMolecule("EthylAcetate2"){
            self.molecule = mol
            setChartData(molecule)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.lineChartView.delegate = self

        if let mol = dataSource.getMolecule(molName!){
            self.molecule = mol
            setChartData(molecule)
            let molView = NSBundle.mainBundle().loadNibNamed("EthylAcetate", owner: self, options: nil).first as! UIView
            moleculePlaceholder.addSubview(molView)
            
            
            let aSelector : Selector = #selector(ViewController.clickSubView)
            let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
            molView.addGestureRecognizer(tapGesture)
        }
    }

    
    func clickSubView(gestureRecognizer: UITapGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Recognized
        {
            print(molecule.getCouplingForPosition(gestureRecognizer.locationInView(gestureRecognizer.view)))
            print(gestureRecognizer.locationInView(gestureRecognizer.view))
            
            if let index = molecule.getCouplingForPosition(gestureRecognizer.locationInView(gestureRecognizer.view)){
                highlightCoupling(index)
                
            }
            

            
        }
    }

    
    
    func highlightCoupling(index:Int){
        
        if molSelection[index] != nil{
        
            self.lineChartView.data?.removeDataSet(molSelection[index]!.0)
            molSelection[index]!.1.removeFromSuperview()

            molSelection.removeValueForKey(index)
            self.lineChartView.notifyDataSetChanged()

        
        }else{
            
        
            let dataSet2: LineChartDataSet = LineChartDataSet(yVals: molecule.signal.slice(
                molecule.couplings[index].ranges.0,
                molecule.couplings[index].ranges.1), label: nil)
            dataSet2.axisDependency = .Left // Line will correlate with left axis values
            dataSet2.setColor(colors[index].colorWithAlphaComponent(0.5)) // our line's opacity is 50%
            dataSet2.setCircleColor(UIColor.redColor()) // our circle will be dark red
            dataSet2.lineWidth = 1.0
            dataSet2.circleRadius = 0.0 // the radius of the node circle
            dataSet2.fillAlpha = 65 / 255.0
            dataSet2.fillColor = UIColor.redColor()
            dataSet2.highlightColor = UIColor.whiteColor()
            dataSet2.drawCircleHoleEnabled = false
            
            self.lineChartView.data?.addDataSet(dataSet2)
            self.lineChartView.notifyDataSetChanged()
            
            
            
            let v = UIView(frame: molecule.couplings[index].boundaries)
            v.backgroundColor = colors[index].colorWithAlphaComponent(0.5)
            v.userInteractionEnabled = false
            v.tag = index+100
            moleculePlaceholder.addSubview(v)

            
            molSelection[index] = (dataSet2, v)
        
        }
        

        
    
    }
    
    func setChartData(molecule: Molecule) {

        let dataSet: LineChartDataSet = LineChartDataSet(yVals: molecule.signal, label: molecule.name)
        
        
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
        dataSets.append(dataSet)
        
        
        
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: molecule.ppm, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        
        
        
        
        
        
        
        //5 - finally set our data
        self.lineChartView.data = data            
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

