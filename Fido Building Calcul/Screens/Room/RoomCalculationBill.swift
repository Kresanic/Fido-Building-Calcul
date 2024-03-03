//
//  RoomCalculationBill.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 02/08/2023.
//

import SwiftUI

struct RoomCalculationBill: View {
    
    @StateObject var viewModel = RoomCalculationViewModel()
    
    @FetchRequest var fetchedRooms: FetchedResults<Room>
    
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    
    @AppStorage("vat") var vat: Double = 20
    
    init(room: Room) {
        
        let roomRequest = Room.fetchRequest()
        
        roomRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Room.name, ascending: true)]
        
        let roomCId = room.cId ?? UUID()
        
        roomRequest.predicate = NSPredicate(format: "cId == %@", roomCId as CVarArg)
        
        _fetchedRooms = FetchRequest(fetchRequest: roomRequest)
        
    }
    
    var body: some View {
     
        if let fetchedRoom = fetchedRooms.first {
            
            let totalPriceWithoutVAT = viewModel.totalPriceForAll(room: fetchedRoom)
            
            if totalPriceWithoutVAT > 0 {
                VStack(spacing: 0) {
                    
                    Text("Celková cenová ponuka")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.brandBlack)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 5)
                    
                    VStack(spacing: 5) {
                        
                        MajorPriceItem(itemName: "Práca", price: viewModel.completePriceForWork(room: fetchedRoom))
                        
                        VStack(spacing: 5) {
                            
                            MinorPriceItem(itemName: "Búracie Práce", price: viewModel.demolitionWorkPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Elektroinštalatérske práce", price: viewModel.electricalWorkPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Vodoinštalatérske práce", price: viewModel.plumbingWorkPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Murovanie priečok", price: viewModel.layingPartitionWallPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Murovanie nosného muriva", price: viewModel.layingLoadBearingWallPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Sádrokartón - strop", price: viewModel.plasterboardCeilingPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Sádrokartón - priečka", price: viewModel.plasterboardPartitionPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Sieťkovanie - stena", price: viewModel.nettingWallPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Sieťkovanie - strop", price: viewModel.nettingCeilingPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Stierka - stena", price: viewModel.plasteringWallPrice(room: fetchedRoom))
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            MinorPriceItem(itemName: "Stierka - strop", price: viewModel.plasteringCeilingPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Osadenie rohovej lišty", price: viewModel.installationOfCornerStripPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Stierkovanie špalety", price: viewModel.plasterinOfRevealPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Penetračný náter", price: viewModel.penetrationCoatPrice(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Maľovanie - stena", price: viewModel.paintingWallPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Maľovanie - strop", price: viewModel.paintingCeilingPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Nivelačka", price: viewModel.levellingPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Pokládka plávajúcej podlahy", price: viewModel.layingOfFloatingFloorPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Lištovanie plavajucej podlahy", price: viewModel.floatingFloorMoldingPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Keramický obklad", price: viewModel.tileCeramicPrices(room: fetchedRoom))
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            MinorPriceItem(itemName: "Keramická dlažba", price: viewModel.pavingCeramicPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Špárovanie obkladu a dlažby", price: viewModel.groutingTilesAndPavingPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Osadenie sanity", price: viewModel.installationOfSanitaryWarePrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Osadenie okna", price: viewModel.installationOfWindowPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Osadenie obložkovej zárubne", price: viewModel.doorFrameInstallationPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Pomocné a ukončovacie práce", price: viewModel.auxilaryWorkPrices(room: fetchedRoom))
                            
                            MajorPriceItem(itemName: "Materiál", price: viewModel.completePriceForMaterials(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Priečkove murivo", price: viewModel.partitionMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Nosné murivo", price: viewModel.loadBearingMasonryMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Kartón - strop", price: viewModel.plasterBoardCeilingMaterialPrices(room: fetchedRoom))
                        }
                        
                        VStack(spacing: 5) {
                            
                            MinorPriceItem(itemName: "Kartón - priečka", price: viewModel.plasterBoardPartitionMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Sklotextilná mriežka", price: viewModel.fiberGlassMeshMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Lepidlo", price: viewModel.adhesiveMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Stierka", price: viewModel.plasterMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Rohová lišta", price: viewModel.cornerMoldingMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Penetrák", price: viewModel.penetrationMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Farba - stena", price: viewModel.wallPaintMaterialPrices(room: fetchedRoom))
                        }
                        
                        VStack(spacing: 5) {
                            
                            MinorPriceItem(itemName: "Farba - strop", price: viewModel.ceilingPaintMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Samonivelizačná hota", price: viewModel.levellingMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Podlaha plávajúca", price: viewModel.floatingFloorMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Soklové lišty", price: viewModel.baseboardMoldingMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Obklad", price: viewModel.wallTileMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Dlažba", price: viewModel.floorTileMaterialPrices(room: fetchedRoom))
                            
                            MinorPriceItem(itemName: "Pomocný a spojovací materiál", price: viewModel.auxiliaryConnectingMaterialPrices(room: fetchedRoom))
                            
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
                                
                                Text(totalPriceWithoutVAT, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                                
                                Text("DPH")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Spacer()
                                
                                Text(totalPriceWithoutVAT*(vat/100), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                                
                                Text("Celková cena")
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Spacer()
                                
                                Text(totalPriceWithoutVAT*(1 + vat/100), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
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

struct MinorPriceItem: View {
    
    var itemName: String
    var price: Double
    
    var body: some View {
        
        if price > 0.0 {
            HStack(alignment: .lastTextBaseline) {
                
                Text(itemName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                Spacer()
                
                Text(price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
        }
        
    }
    
}
