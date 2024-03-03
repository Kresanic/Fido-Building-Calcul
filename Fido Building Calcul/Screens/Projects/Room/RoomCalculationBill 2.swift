//
//  RoomCalculationBill.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct RoomCalculationBill: View {
    
//    @StateObject var viewModel: RoomCalculationViewModel
    
    @EnvironmentObject var pricingCalc: PricingCalculations
    
    @FetchRequest var fetchedRooms: FetchedResults<Room>
    
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    @State var priceList: PriceList?
    
    @Binding var isShowing: Bool
    
    init(room: Room, isShowing: Binding<Bool>) {
        
        self._isShowing = isShowing
        
//        self._viewModel = StateObject(wrappedValue: RoomCalculationViewModel(project: room.fromProject))
        
        let priceList = room.fromProject?.toPriceList
        
        self._priceList = State(wrappedValue: priceList)
        
        let roomRequest = Room.fetchRequest()
        
        roomRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.name, ascending: true)]
        
        let roomCId = room.cId ?? UUID()
        
        roomRequest.predicate = NSPredicate(format: "cId == %@", roomCId as CVarArg)
        
        _fetchedRooms = FetchRequest(fetchRequest: roomRequest)
        
    }
    
    var body: some View {
     
        if isShowing {
            
            if let fetchedRoom = fetchedRooms.first, let priceList {
                
                
                let calculations: PriceBill = pricingCalc.roomPriceBillCalculation(room: fetchedRoom, priceList: priceList)
                
                if calculations.priceWithoutVat > 0 {
                    
                    VStack(spacing: 0) {
                        
                        Text("Celková cenová ponuka")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 5)
                        
                        VStack(spacing: 5) {
                            
                            MajorPriceItem(itemName: "Práca", price: calculations.worksPrice)
                            
                            ForEach(calculations.works) { work in
                                PriceBillRowView(itemName: work.name, pieces: work.pieces, unit: work.unit, price: work.price)
                            }
                            
                            MajorPriceItem(itemName: "Materiál", price: calculations.materialsPrice)
                            
                            ForEach(calculations.materials) { material in
                                PriceBillRowView(itemName: material.name, pieces: material.pieces, unit: material.unit, price: material.price)
                            }
                            
                            MajorPriceItem(itemName: "Ostatné", price: calculations.othersPrice)
                            
                            ForEach(calculations.others) { material in
                                PriceBillRowView(itemName: material.name, pieces: material.pieces, unit: material.unit, price: material.price)
                            }
                            
                            RoundedRectangle(cornerRadius: 9)
                                .foregroundStyle(Color.brandWhite)
                                .frame(height: 2)
                            
                            VStack {
                                
                                HStack(alignment: .firstTextBaseline) {
                                    
                                    Text("Cena bez DPH")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                    Spacer()
                                    
                                    Text(calculations.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                }
                                
                                HStack(alignment: .firstTextBaseline) {
                                    
                                    Text("DPH")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                    Spacer()
                                    
                                    Text(calculations.priceWithoutVat*(priceList.othersVatPrice/100), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                }
                                
                                HStack(alignment: .firstTextBaseline) {
                                    
                                    Text("Celková cena")
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                                        .font(.system(size: 26, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                    Spacer(minLength: 20)
                                    
                                    Text(calculations.priceWithoutVat*(1 + priceList.othersVatPrice/100), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                                        .font(.system(size: 26, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                        
                                    
                                }
                                
                            }
                            
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        .background(Color.brandGray)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.bottom, behavioursVM.toRedraw ? 0.5 : 0)
                    }
                }
                
            }
            
        }
        
    }
    
}

struct MajorPriceItem: View {
    
    var itemName: String
    var price: Double
    
    var body: some View {
        
        if price > 0.0 {
            HStack {
                
                Text(itemName)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                Spacer()
                
                Text(price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
            }
        }
        
    }
}

struct PriceBillRowView: View {
    
    var itemName: String
    var pieces: Double?
    var unit: UnitsOfMeasurment?
    var price: Double
    
    var body: some View {
        
        if price > 0.0 {
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                
                if var pieces, let unit {
                    
                    Text("\(itemName) - \(pieces.roundAndRemoveZerosFromEnd())\(UnitsOfMeasurment.readableSymbol(unit))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                    
                } else {
                    Text(itemName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                }
                
                Spacer()
                
                Text(price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
        }
        
    }
    
}

struct MinorPriceItem: View {
    
    var itemName: String
    var price: Double
    
    var body: some View {
        
        if price > 0.0 {
            HStack(alignment: .lastTextBaseline) {
                
                Text(itemName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .lineLimit(1)
                
                Spacer()
                
                Text(price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
        }
        
    }
    
}
