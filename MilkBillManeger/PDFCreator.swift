//
//  PDFCreator.swift
//  MilkBillManeger
//
//  Created by Coditas on 28/03/22.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
    var pageRect = CGRect()
    var rate = 60
    var cowMilkLiter : Float = 0.0
    var cowmilkTotal : Float = 0.0
    var buffaloMilkLiter : Float = 0.0
    var buffaloMilkTotal : Float = 0.0
    
    var totalAmount : Float = 0.0
    var dataToPrintInPdf : DataToPrintInBillCalculator?
    var viewModel = BillManegerViewModel()
    
    func createFlyer() -> Data {
        let pdfMetaData = [
        kCGPDFContextCreator: "Rutuja",
        kCGPDFContextAuthor: "Rutuja"
      ]
      let format = UIGraphicsPDFRendererFormat()
      format.documentInfo = pdfMetaData as [String: Any]
        valueCalculate()
      // 2
      //let pageWidth = 10 * 72.0
      //let pageHeight = 13 * 72.0
        let screenSize : CGRect = UIScreen.main.bounds
        pageRect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 130)

      let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
      let data = renderer.pdfData { (context) in
        context.beginPage()
        boldLabel(frame: pageRect, text: "Bill Calculator", textSize: 30, color: UIColor.black)
       // createLabel(frame: CGRect(x: pageRect.minX + 10, y: 10, width: pageRect.width, height: pageRect.height), fontSize: 30, color: UIColor.black, text: "Bill Calculator")
        let lineBelowBillCLabel = drawLine(frame: CGRect(x: pageRect.minX, y: pageRect.minY + 50, width: pageRect.width, height: pageRect.height), lineWidth: 1.5, color: UIColor.black.cgColor)
        headerLabels(frame: CGRect(x: pageRect.minX + 10, y: pageRect.minY + 55, width: pageRect.width - 10, height: 30),color : UIColor.systemBlue, text1: "Type",text2: "Liter",text3: "Rate",text4: "Total", textSize: 22)
        let lineBelowHeaderLbls = drawLine(frame: CGRect(x: pageRect.minX, y: pageRect.minY + 95, width: pageRect.width, height: pageRect.height), lineWidth: 1.0, color: UIColor.black.cgColor)
        cellLabels(frame: CGRect(x: pageRect.minX + 10, y: pageRect.minY + 110, width: pageRect.width - 10, height: 40), color: UIColor.black, text1: "Cow",text2: "\(cowMilkLiter)",text3: "\(rate)",text4: "\(cowmilkTotal)",textSize: 18)
        
        let numberOfLines = 2
        var yValue = 0

        for _ in 1...numberOfLines{
            drawLine(frame: CGRect(x: pageRect.minX, y: pageRect.minY + 145 + CGFloat(yValue), width: pageRect.width, height: pageRect.height), lineWidth: 1.0, color: UIColor.lightGray.cgColor)
            yValue += 50
        }
        cellLabels(frame: CGRect(x: pageRect.minX + 10, y: pageRect.minY + 155, width: pageRect.width - 10, height: 40), color: UIColor.black, text1: "Buffalo",text2: "\(buffaloMilkLiter)",text3: "\(rate)",text4: "\(buffaloMilkTotal)",textSize: 18)
        
        let bottomLine = drawLine(frame: CGRect(x: pageRect.minX + 10, y: pageRect.maxY - 80, width: pageRect.width - 10, height: pageRect.height), lineWidth: 1.5, color: UIColor.black.cgColor)
        
        let bottomTotalLbl = boldLabel(frame: CGRect(x: pageRect.minX + 20, y: pageRect.maxY - 70, width: 150, height: 50), text: "TOTAL - ", textSize: 20, color: UIColor.black)
        
        let totalValue = boldLabel(frame: CGRect(x: pageRect.maxX - 100, y: pageRect.maxY - 70, width: 150, height: 50), text: "\(totalAmount)", textSize: 20, color: UIColor.black)
      }
      return data
    }
    func valueCalculate(){
        viewModel.fetchResultForBillCalculation { (arrayData, totalValue) in
                self.dataToPrintInPdf = arrayData
                self.totalAmount = (totalValue)
            print("dataToPrintInTable",self.dataToPrintInPdf!)
            self.cowMilkLiter = (self.dataToPrintInPdf?.dataToPrint![0].liter)!
            self.cowmilkTotal = (self.dataToPrintInPdf?.dataToPrint![0].total)!
            
            self.buffaloMilkLiter = (self.dataToPrintInPdf?.dataToPrint![1].liter)!
            self.buffaloMilkTotal = (self.dataToPrintInPdf?.dataToPrint![1].total)!

        }
    }
    func boldLabel(frame : CGRect, text: String, textSize: CGFloat, color : UIColor){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
         // NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textSize)
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: textSize),
            NSAttributedString.Key.foregroundColor : color,
            NSAttributedString.Key.paragraphStyle : paragraphStyle
        ]
        let text = text
        text.draw(at: CGPoint(x: frame.minX + 10, y: frame.minY + 10), withAttributes: attributes)
    }
    
    func label(frame : CGRect, text: String, textSize: CGFloat, color : UIColor){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
         // NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textSize)
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: textSize),
            NSAttributedString.Key.foregroundColor : color,
            NSAttributedString.Key.paragraphStyle : paragraphStyle
        ]
        let text = text
        text.draw(at: CGPoint(x: frame.minX + 10, y: frame.minY + 10), withAttributes: attributes)
    }
    
//    func createLabel(frame : CGRect, fontSize : CGFloat, color : UIColor, text : String){
//        let label = UILabel()
//            //label.frame = CGRect(x: frame.minX + 10, y: frame.midY + 10, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
//        label.text = text
//        label.font = UIFont.systemFont(ofSize: fontSize)
//        label.textColor = color
//        label.drawText(in: frame)
//    }
    func drawLine(frame : CGRect, lineWidth : CGFloat, color : CGColor){
        guard let context = UIGraphicsGetCurrentContext() else { return }
            let lineWidth: CGFloat = lineWidth
            context.setLineWidth(lineWidth)
        context.setStrokeColor(color)
        //context.setStrokeColor(UIColor(.tertiaryBackground).cgColor)
        let startingPoint = CGPoint(x: frame.minX + 10, y: frame.minY + 10)
        let endingPoint = CGPoint(x: frame.maxX - 10, y: frame.minY + 10)
            context.move(to: startingPoint)
            context.addLine(to: endingPoint)
            context.strokePath()
    }
    
    func headerLabels(frame : CGRect, color : UIColor,text1 : String,text2 : String, text3: String, text4 : String, textSize : CGFloat){
        boldLabel(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.width), text: text1, textSize: textSize, color: color)
        boldLabel(frame: CGRect(x: frame.minX + 100, y: frame.minY, width: frame.height, height: frame.width), text: text2, textSize: textSize, color: color)
        boldLabel(frame: CGRect(x: frame.minX + 200, y: frame.minY, width: frame.height, height: frame.width), text: text3, textSize: textSize, color: color)
        boldLabel(frame: CGRect(x: frame.minX + 300, y: frame.minY, width: frame.height, height: frame.width), text: text4, textSize: textSize, color: color)
    }
    
    func cellLabels(frame : CGRect, color : UIColor,text1 : String,text2 : String, text3: String, text4 : String, textSize : CGFloat){
        label(frame: CGRect(x: frame.minX + 10, y: frame.minY, width: frame.height, height: frame.width), text: text1, textSize: textSize, color: color)
        label(frame: CGRect(x: frame.minX + 110, y: frame.minY, width: frame.height, height: frame.width), text: text2, textSize: textSize, color: color)
        label(frame: CGRect(x: frame.minX + 210, y: frame.minY, width: frame.height, height: frame.width), text: text3, textSize: textSize, color: color)
        label(frame: CGRect(x: frame.minX + 310, y: frame.minY, width: frame.height, height: frame.width), text: text4, textSize: textSize, color: color)
    }
    
    
    
    

}
