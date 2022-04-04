//
//  PDFViewController.swift
//  MilkBillManeger
//
//  Created by Coditas on 28/03/22.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

    @IBOutlet weak var pdfView : PDFView!
    static let identifier = String(describing: PDFViewController.self)
    public var documentData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = documentData {
            if let doc = PDFDocument(data: data){
                pdfView.document = doc
                pdfView.autoScales = true
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonClicked))
    }
    
    @objc func shareButtonClicked(){
        let items = [URL(string: "https://www.apple.com")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    

}
