//
//  InvoicePreviewSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/04/2024.
//

import SwiftUI
import PDFKit

struct InvoicePreviewSheet: View {
    
    @Environment(\.dismiss) var dismiss
    var project: Project
    let pdfURL: URL
    let cashReceiptURL: URL?
    @State var pdfDoc: PDFDocument?
    @State var cashReceiptDoc: PDFDocument?
    @State var showingShareSheet = false
    @State var pageIndex = 1
    @State var isSending = false
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        VStack {
            
            TabView(selection: $pageIndex) {
                if let pdfDoc {
                    PDFKitView(showing: pdfDoc)
                        .padding(.top, 40)
                        .tag(1)
                } else { Text("Loading...") }
                
                if let cashReceiptDoc {
                    PDFKitView(showing: cashReceiptDoc)
                        .padding(.top, 40)
                        .tag(2)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle())
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                    isSending = false
                }
            }
            .padding(.bottom, 100)
        }
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
                
                SharePDFView(project: project, pdfURL: pdfURL, receiptURL: cashReceiptURL, pageIndex: pageIndex, isSending: $isSending)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brandGray)
        .ignoresSafeArea()
        .task {
            withAnimation { pdfDoc = PDFDocument(url: pdfURL) }
            if let cashReceiptURL {
                withAnimation { cashReceiptDoc = PDFDocument(url: cashReceiptURL) }
            }
        }
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
        if let brandGray = UIColor(named: "brandGray") {
            pdfView.backgroundColor = brandGray
        }
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}


struct SharePDFView: View {
    
    let project: Project
    let pdfURL: URL
    let receiptURL: URL?
    var pageIndex: Int
    @Environment(\.managedObjectContext) var viewContext
    @Binding var isSending: Bool
    @Namespace var namingSpace: Namespace.ID
    
    var body: some View {
        
        if let receiptURL {
            // Does have cash receipt, option to sent more
            VStack {
                if isSending {
                    
                    Text("Send")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .trailing) {
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                                    isSending = false
                                }
                            } label: {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color.brandBlack)
                                    .padding([.leading, .top, .bottom], 15)
                            }
                        }
                    
                    ShareLink(item: pageIndex == 1 ? pdfURL : receiptURL) {
                        
                        HStack(spacing: 5) {
                            
                            let invoiceLoc = NSLocalizedString("InvoiceJS", comment: "just")
                            let receiptLoc = NSLocalizedString("Receipt", comment: "just")
                            
                            Text("Send Just \(pageIndex == 1 ? invoiceLoc : receiptLoc)")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandWhite)
                            
                            Image(systemName:  pageIndex == 1 ? "doc.text.fill" : "scroll.fill" )
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.brandWhite)
                            
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandBlack)
                        .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    }.simultaneousGesture(TapGesture().onEnded() {
                        // TODO: FILL IN
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    ShareLink(items: [pdfURL, receiptURL]) {
                        
                        HStack(spacing: 5) {
                            
                            Text("Send Invoice and Receipt")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.brandWhite)
                            
                            Image(systemName: "doc.on.doc.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.brandWhite)
                            
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandBlack)
                        .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    }.simultaneousGesture(TapGesture().onEnded() {
                        // TODO: FILL IN
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                } else {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                            isSending = true
                        }
                    } label: {
                        HStack(spacing: 5) {
                            
                            Text("Send")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.brandWhite)
                            
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(Color.brandBlue)
                            
                        }.padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Color.brandBlack)
                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    }.transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.top, 15)
            .padding(.horizontal, 20)
            .padding(.bottom, 35)
            .background(Color.brandWhite.opacity(0.5))
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: isSending ? 20 : 0, style: .continuous))
            
        } else {
            // Does not have cash receipt, sending just PDF Invoice
            ShareLink(item: pdfURL) {
                
                HStack(spacing: 5) {
                    
                    Text("Send")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.brandWhite)
                    
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.brandBlue)
                    
                }.padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color.brandBlack)
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
            }
            .padding(.top, 15)
            .padding(.horizontal, 20)
            .padding(.bottom, 35)
            .background(Color.brandWhite.opacity(0.5))
            .background(.ultraThinMaterial)
            .simultaneousGesture(TapGesture().onEnded() {
                project.addToToHistoryEvent(ProjectEvents.invoiceSent.entityObject)
                project.addToToHistoryEvent(ProjectEvents.finished.entityObject)
                project.status = 3
                try? viewContext.save()
            })
        }
        
        
    }
    
}
