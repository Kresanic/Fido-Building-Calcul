//
//  Custom View Modifiers.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI
import Combine

extension View {
 
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
    
    func styleOfBubblesInSettings(subTitle: LocalizedStringKey? = nil) -> some View {
        return modifier(StyleOfBubblesInSettings(subTitle: subTitle))
    }
    
    func redrawable() -> some View {
        return modifier(Redrawable())
    }
    
    func ctaPopUp() -> some View {
        return modifier(CTAPopUp())
    }
    
    func invoiceBuilderToolbar(focused: FocusState<InvoiceBuilderItemFocuses?>.Binding, _ pieces: Binding<String>,_ pricePerPiece: Binding<String>,_ vat: Binding<String>,_ withoutVAT: Binding<String>) -> some View {
        modifier(InvoiceItemInputsToolBar(focusedDimension: focused, pieces: pieces, pricePerPiece: pricePerPiece, vat: vat, withoutVAT: withoutVAT))
    }
    
    func tripleWorkInputsToolbar(focusedDimension: FocusState<TripleFocusedDimension?>.Binding, size1: Binding<String>, size2: Binding<String>, size3: Binding<String>) -> some View {
        return modifier(TripleWorkInputsToolBar(focusedDimension: focusedDimension, size1: size1, size2: size2, size3: size3))
    }
    
    func workInputsToolbar(focusedDimension: FocusState<FocusedDimension?>.Binding, size1: Binding<String>, size2: Binding<String>) -> some View {
        return modifier(WorkInputsToolBar(focusedDimension: focusedDimension, size1: size1, size2: size2))
    }
    
    func singleWorkInputsToolbar(focusedDimension: FocusState<FocusedDimension?>.Binding, size: Binding<String>) -> some View {
        return modifier(SingleWorkInputToolBar(focusedDimension: focusedDimension, size: size))
    }
    
    func redraw(on toggle: Bool) -> some View {
        return modifier(Redraw(toggle: toggle))
    }
    
}

struct Redraw: ViewModifier {
    
    var toggle: Bool
    
    func body(content: Content) -> some View {
        if toggle {
            content
        } else {
            content
        }
    }
    
}

struct AdaptsToKeyboard: ViewModifier {
    
    @State var currentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            withAnimation(.easeOut(duration: 0.16)) {
                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                            }
                    }
                    .map { rect in
                        rect.height - geometry.safeAreaInsets.bottom
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}

struct RoomBubbleViewDeletion: ViewModifier {
    
    @Binding var isDeleting: Bool
    var atButtonPress: () -> Void
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            
            if isDeleting {
                Button {
                    atButtonPress()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 25))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxHeight: .infinity)
                        .frame(width: 75)
                        .background(Color.brandRed)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
            }
        
            content
                .offset(x: isDeleting ? -85 : 0)
                .padding(.leading, isDeleting ? 85 : 0)
            
        }
        
        
    }
    
}

struct StyleOfBubblesInSettings: ViewModifier {
    
    var subTitle: LocalizedStringKey? = nil
    
    func body(content: Content) -> some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 1) {
                content
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
             
                if let subTitle = subTitle {
                    Text(subTitle)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.brandBlack.opacity(0.8))
                }
                
            }
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.brandBlack)
            
        }.padding(.horizontal, 15)
            .frame(height: 65)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
    
}

struct ClientBubbleViewDeletion: ViewModifier {
    
    @Binding var isDeleting: Bool
    var atButtonPress: () -> Void
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            
            if isDeleting {
                Button {
                    atButtonPress()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 25))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxHeight: .infinity)
                        .frame(width: 80)
                        .background(Color.brandRed)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
            }
            
            content
                .offset(x: isDeleting ? -90 : 0)
                .padding(.leading, isDeleting ? 90 : 0)
            
        }
        
    }
    
}

struct ProjectBubbleViewDeletion: ViewModifier {
    
    @Binding var isDeleting: Bool
    var atButtonPress: () -> Void
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            
            if isDeleting {
                Button {
                    atButtonPress()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 25))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxHeight: .infinity)
                        .frame(width: 80)
                        .background(Color.brandRed)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
            }
            
            content
                .offset(x: isDeleting ? -90 : 0)
                .padding(.leading, isDeleting ? 90 : 0)
            
        }
        
    }
    
}

struct ProjectBubbleViewArchival: ViewModifier {
    
    @Binding var isDeleting: Bool
    var atButtonPress: () -> Void
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            
            if isDeleting {
                Button {
                    atButtonPress()
                } label: {
                    Image(systemName: "archivebox")
                        .font(.system(size: 25))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxHeight: .infinity)
                        .frame(width: 80)
                        .background(Color.brandRed)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                }
            }
            
            content
                .offset(x: isDeleting ? -90 : 0)
                .padding(.leading, isDeleting ? 90 : 0)
            
        }
        
    }
    
}

struct Redrawable: ViewModifier {
    
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    
    func body(content: Content) -> some View {
        
        if behaviourVM.toRedraw {
            content
        } else {
            content
        }
        
    }
    
}

struct InvoiceItemInputsToolBar: ViewModifier {
    
    var focusedDimension: FocusState<InvoiceBuilderItemFocuses?>.Binding
    @Binding var pieces: String
    @Binding var pricePerPiece: String
    @Binding var vat: String
    @Binding var withoutVAT: String
    let impactMed = UIImpactFeedbackGenerator(style: .light)
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    enum ButtonType { case done, next }
    
    func body(content: Content) -> some View {
               
            content
                .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            if focusedDimension.wrappedValue != nil {
                                keyboardToolbarContent()
                            }
                        }
                    }
                }
        
    @ViewBuilder
    private func keyboardToolbarContent() -> some View {
        HStack(spacing: 0) {
            if focusedDimension.wrappedValue == .withoutVAT {
                Spacer().frame(width: 75)
                mathSymbols()
                button(.done)
            } else {
                button(.done)
                mathSymbols()
                button(.next)
            }
        }
    }

    private func button(_ type: ButtonType) -> some View {
        Button {
            changeOccurred(shouldHide: type == .done ? true : false)
        } label: {
            Text(type == .done ? "Done" : "Next")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
                .frame(width: 75)
        }
    }
    
    private func mathSymbols() -> some View {
        
        HStack {
            
            Button("-") {
                addSymbol("-")
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("+") {
                addSymbol("+")
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("*") {
                addSymbol("*")
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            
            Button("=") {
                changeOccurred(shouldAdvance: false)
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
        }.font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.brandBlack)
        
    }
    
    private func calculate(on expressionString: String) -> String {
        
        guard let _ = Int(expressionString.suffix(1)) else { return "0" }
        guard let _ = Int(expressionString.prefix(1)) else { return "0" }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
                
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return "0" }
        
        let roundedResult = Double(round(100 * result) / 100)

        return roundedResult.toString
        
    }
    
    private func changeOccurred(shouldHide: Bool = false, shouldAdvance: Bool = true) {
        withAnimation {
            switch focusedDimension.wrappedValue {
            case .some(let focused):
                switch focused {
                case .count:
                    changedCount()
                case .pricePerPiece:
                    changedPricePerCount()
                case .VAT:
                    changedVAT()
                case .withoutVAT:
                    changedVAT()
                }
            case .none:
                break
            }
            if shouldHide {
                focusedDimension.wrappedValue = nil
            } else {
                if shouldAdvance {
                    focusedDimension.wrappedValue = focusedDimension.wrappedValue?.advance
                }
            }
            
        }
    }
    
    private func addSymbol(_ s: String) {
        switch focusedDimension.wrappedValue {
        case .some(let focused):
            switch focused {
            case .count:
                if let last = pieces.last, !["+","*","-"].contains(last) {
                    pieces = pieces + s
                } else {
                    impactHeavy.impactOccurred()
                }
            case .pricePerPiece:
                if let last = pricePerPiece.last, !["+","*","-"].contains(last) {
                    pricePerPiece = pricePerPiece + s
                } else {
                    impactHeavy.impactOccurred()
                }
            case .VAT:
                if let last = vat.last, !["+","*","-"].contains(last) {
                    vat = vat + s
                } else {
                    impactHeavy.impactOccurred()
                }
            case .withoutVAT:
                if let last = withoutVAT.last, !["+","*","-"].contains(last) {
                    withoutVAT = withoutVAT + s
                } else {
                    impactHeavy.impactOccurred()
                }
            }
        case .none:
            break
        }
        impactMed.impactOccurred()
    }
    
    private func changedCount() {
        withAnimation {
            pieces = calculate(on: pieces)
            pricePerPiece = (withoutVAT.toDouble/pieces.toDouble).round.toString
        }
    }
    
    private func changedPricePerCount() {
        withAnimation {
            pricePerPiece = calculate(on: pricePerPiece)
            withoutVAT = (pricePerPiece.toDouble*pieces.toDouble).round.toString
        }
    }
    
    private func changedVAT() {
        withAnimation {
            vat = calculate(on: vat)
        }
    }
    
    private func changedWithoutVAT() {
        withAnimation {
            withoutVAT = calculate(on: withoutVAT)
            pricePerPiece = (withoutVAT.toDouble/pieces.toDouble).round.toString
        }
    }
    
}

struct TripleWorkInputsToolBar: ViewModifier {
    
    var focusedDimension: FocusState<TripleFocusedDimension?>.Binding
    @Binding var size1: String
    @Binding var size2: String
    @Binding var size3: String
    
    func body(content: Content) -> some View {
               
            content
                .toolbar {
                        ToolbarItem(placement: .keyboard) {
                                if focusedDimension.wrappedValue != nil {
                                    if focusedDimension.wrappedValue == .first {
                                        keyboardToolbarContent(for: .first)
                                    } else if focusedDimension.wrappedValue == .second {
                                        keyboardToolbarContent(for: .second)
                                    } else if focusedDimension.wrappedValue == .third {
                                            keyboardToolbarContent(for: .third)
                                    }
                                }
                        }
                        
                    }
                }
        
    @ViewBuilder
    private func keyboardToolbarContent(for dimension: TripleFocusedDimension) -> some View {
        HStack(spacing: 0) {
            if dimension == .first || dimension == .second {
                doneButton().frame(width: 75)
                mathSymbols()
                nextButton().frame(width: 75)
            } else if dimension == .third {
                Spacer().frame(width: 75)
                mathSymbols()
                doneButton().frame(width: 75)
            }
        }
    }

    private func doneButton() -> some View {
        Button {
            withAnimation {
                focusedDimension.wrappedValue = nil
                size1 = calculate(on: size1)
                size2 = calculate(on: size2)
                size3 = calculate(on: size3)
            }
        } label: {
            Text("Done")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
    }

    private func nextButton() -> some View {
        Button {
            withAnimation {
                focusedDimension.wrappedValue = focusedDimension.wrappedValue?.advance
                size1 = calculate(on: size1)
                size2 = calculate(on: size2)
            }
        } label: {
            Text("Next")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
    }
    
    private func mathSymbols() -> some View {
        
        HStack {
            
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            
            Button("-") {
                if focusedDimension.wrappedValue == .first {
                    size1 = size1 + "-"
                } else if focusedDimension.wrappedValue == .second {
                    size2 = size2 + "-"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("+") {
                if focusedDimension.wrappedValue == .first {
                    size1 = size1 + "+"
                } else if focusedDimension.wrappedValue == .second {
                    size2 = size2 + "+"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("*") {
                if focusedDimension.wrappedValue == .first {
                    size1 = size1 + "*"
                } else if focusedDimension.wrappedValue == .second {
                    size2 = size2 + "*"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            
            Button("=") {
                if focusedDimension.wrappedValue == .first {
                    size1 = calculate(on: size1)
                } else if focusedDimension.wrappedValue == .second {
                    size2 = calculate(on: size2)
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
        }.font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.brandBlack)
        
    }
    
    private func calculate(on expressionString: String) -> String {
        
        guard let _ = Int(expressionString.suffix(1)) else { return "0" }
        guard let _ = Int(expressionString.prefix(1)) else { return "0" }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
                
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return "0" }
        
        let roundedResult = Double(round(100 * result) / 100)

        return dbToStr(from: roundedResult)
        
    }
    
    private func dbToStr(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
}

struct WorkInputsToolBar: ViewModifier {
    
    var focusedDimension: FocusState<FocusedDimension?>.Binding
    @Binding var size1: String
    @Binding var size2: String
    
    func body(content: Content) -> some View {
               
            content
                .toolbar {
                        ToolbarItem(placement: .keyboard) {
                                if focusedDimension.wrappedValue != nil {
                                    if focusedDimension.wrappedValue == .first {
                                        keyboardToolbarContent(for: .first)
                                    } else if focusedDimension.wrappedValue == .second {
                                        keyboardToolbarContent(for: .second)
                                    }
                                }
                        }
                        
                    }
                }
        
    @ViewBuilder
    private func keyboardToolbarContent(for dimension: FocusedDimension) -> some View {
        HStack(spacing: 0) {
            if dimension == .first {
                doneButton().frame(width: 75)
                mathSymbols()
                nextButton().frame(width: 75)
            } else if dimension == .second {
                Spacer().frame(width: 75)
                mathSymbols()
                doneButton().frame(width: 75)
            }
        }
    }

    private func doneButton() -> some View {
        Button {
            withAnimation {
                focusedDimension.wrappedValue = nil
                size1 = calculate(on: size1)
                size2 = calculate(on: size2)
            }
        } label: {
            Text("Done")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
    }

    private func nextButton() -> some View {
        Button {
            withAnimation {
                focusedDimension.wrappedValue = .second
                size1 = calculate(on: size1)
            }
        } label: {
            Text("Next")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
    }
    
    private func mathSymbols() -> some View {
        
        HStack {
            
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            
            Button("-") {
                if focusedDimension.wrappedValue == .first {
                    size1 = size1 + "-"
                } else if focusedDimension.wrappedValue == .second {
                    size2 = size2 + "-"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("+") {
                if focusedDimension.wrappedValue == .first {
                    size1 = size1 + "+"
                } else if focusedDimension.wrappedValue == .second {
                    size2 = size2 + "+"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("*") {
                if focusedDimension.wrappedValue == .first {
                    size1 = size1 + "*"
                } else if focusedDimension.wrappedValue == .second {
                    size2 = size2 + "*"
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            
            Button("=") {
                if focusedDimension.wrappedValue == .first {
                    size1 = calculate(on: size1)
                } else if focusedDimension.wrappedValue == .second {
                    size2 = calculate(on: size2)
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
        }.font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.brandBlack)
        
    }
    
    private func calculate(on expressionString: String) -> String {
        
        guard let _ = Int(expressionString.suffix(1)) else { return "0" }
        guard let _ = Int(expressionString.prefix(1)) else { return "0" }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
                
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return "0" }
        
        let roundedResult = Double(round(100 * result) / 100)

        return dbToStr(from: roundedResult)
        
    }
    
    private func dbToStr(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
}

struct SingleWorkInputToolBar: ViewModifier {
    
    var focusedDimension: FocusState<FocusedDimension?>.Binding
    @Binding var size: String
    
    func body(content: Content) -> some View {
        
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    if focusedDimension.wrappedValue == .first {
                        keyboardToolbarContent(for: .first)
                    }
                }
            }
        
    }
        
    @ViewBuilder
    private func keyboardToolbarContent(for dimension: FocusedDimension) -> some View {
        HStack(spacing: 0) {
            if dimension == .first {
                Spacer().frame(width: 75)
                mathSymbols()
                doneButton().frame(width: 75)
            }
        }
    }

    private func doneButton() -> some View {
        Button {
            withAnimation {
                focusedDimension.wrappedValue = nil
                size = calculate(on: size)
            }
        } label: {
            Text("Done")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background { Color.brandBlack }
                .clipShape(Capsule())
        }
    }
    
    private func mathSymbols() -> some View {
        
        HStack {
            
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            
            Button("-") {
                if focusedDimension.wrappedValue == .first { size = size + "-" }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("+") {
                if focusedDimension.wrappedValue == .first { size = size + "+" }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button("*") {
                if focusedDimension.wrappedValue == .first { size = size + "*" }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            
            Button("=") {
                if focusedDimension.wrappedValue == .first {
                    size = calculate(on: size)
                }
                impactMed.impactOccurred()
            }.frame(height: 40)
            .frame(maxWidth: .infinity)
            
        }.font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.brandBlack)
        
    }
    
    private func calculate(on expressionString: String) -> String {
        
        guard let _ = Int(expressionString.suffix(1)) else { return "0" }
        guard let _ = Int(expressionString.prefix(1)) else { return "0" }
        
        let expression = expressionString.replacingOccurrences(of: ",", with: ".")
                
        let express = NSExpression(format: expression)
        
        guard let result = express.expressionValue(with: nil, context: nil) as? Double else { return "0" }
        
        let roundedResult = Double(round(100 * result) / 100)
        
        return dbToStr(from: roundedResult)
        
    }
    
    private func dbToStr(from number: Double) -> String {
        
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return String(number) == "0.0" ? "" : String(Int(number))
        } else {
            return String(number) == "0.0" ? "" : String(number).replacingOccurrences(of: ".", with: ",")
        }
        
    }
    
}
