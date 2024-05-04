//
//  InvoicePDFDocumentPreviewSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 04/05/2024.
//

import SwiftUI
import PDFKit

struct InvoicePDFDocumentPreviewSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State var pdfDoc: PDFDocument?
    
    var body: some View {
        VStack {
            if let pdfDoc {
                PDFKitView(showing: pdfDoc)
                    .padding(.top, 40)
            } else { Text("Loading...") }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .center) {
            
            VStack {
                
                HStack {
                    
                    Spacer().frame(width: 50)
                    
                    Text("Invoice Preview")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                    }.frame(width: 50, alignment: .trailing)
                    
                }.padding(15)
                    .padding([.top, .horizontal], 5)
                    .background(Color.brandWhite.opacity(0.5))
                    .background(.ultraThinMaterial)
                
                Spacer()
                
            }
            
        }
        .background(Color.brandGray)
        .ignoresSafeArea()
        .presentationCornerRadius(30)
        
    }
    
}


fileprivate struct PDFKitView: UIViewRepresentable {

    let pdfDocument: PDFDocument

    init(showing pdfDoc: PDFDocument) {
        self.pdfDocument = pdfDoc
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
    
}
