//
//  Materials.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 28/11/2023.
//

import SwiftUI

public class PartitionMasonry: MaterialType {
    
    static var title: LocalizedStringKey = "Partition masonry"
    static var subTitle: LocalizedStringKey = "75 - 175mm"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class LoadBearingMasonry: MaterialType {
    
    static var title: LocalizedStringKey = "Load-bearing masonry"
    static var subTitle: LocalizedStringKey = "200 - 450mm"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class SimplePlasterboardPartition: MaterialType {
    
    static var title: LocalizedStringKey = "Plasterboard"
    static var subTitle: LocalizedStringKey = "simple, partition"
    static var billSubTitle: LocalizedStringKey = "Plasterboard, simple partition"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .piece
    
}

public class DoublePlasterboardPartition: MaterialType {
    
    static var title: LocalizedStringKey = "Plasterboard"
    static var subTitle: LocalizedStringKey = "double, partition"
    static var billSubTitle: LocalizedStringKey = "Plasterboard, double partition"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .piece
    
}

public class TriplePlasterboardPartition: MaterialType {
    
    static var title: LocalizedStringKey = "Plasterboard"
    static var subTitle: LocalizedStringKey = "triple, partition"
    static var billSubTitle: LocalizedStringKey = "Plasterboard, triple partition"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .piece
    
}

public class PlasterboardCeiling: MaterialType {
    
    static var title: LocalizedStringKey = "Plasterboard"
    static var subTitle: LocalizedStringKey = "ceiling"
    static var billSubTitle: LocalizedStringKey = "Plasterboard, ceiling"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .piece
    
}

public class Mesh: MaterialType {
    
    static var title: LocalizedStringKey = "Mesh"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class AdhesiveNetting: MaterialType {
    
    static var title: LocalizedStringKey = "Adhesive"
    static var subTitle: LocalizedStringKey = "netting"
    static var billSubTitle: LocalizedStringKey = "Adhesive, netting"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .package
    
}

public class AdhesiveTilingAndPaving: MaterialType {
    
    static var title: LocalizedStringKey = "Adhesive"
    static var subTitle: LocalizedStringKey = "tiling and paving"
    static var billSubTitle: LocalizedStringKey = "Adhesive, tiling and paving"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .package
    
}

public class Plaster: MaterialType {
    
    static var title: LocalizedStringKey = "Plaster"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .package
    
}

public class CornerBead: MaterialType {
    
    static var title: LocalizedStringKey = "Corner bead"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .basicMeter
    static var capacityUnity: UnitsOfMeasurment? = .piece
    
}

public class Primer: MaterialType {
    
    static var title: LocalizedStringKey = "Primer"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class PaintWall: MaterialType {
    
    static var title: LocalizedStringKey = "Paint"
    static var subTitle: LocalizedStringKey = "wall"
    static var billSubTitle: LocalizedStringKey = "Paint, wall"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class PaintCeiling: MaterialType {
    
    static var title: LocalizedStringKey = "Paint"
    static var subTitle: LocalizedStringKey = "ceiling"
    static var billSubTitle: LocalizedStringKey = "Paint, ceiling"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class SelfLevellingCompound: MaterialType {
    
    static var title: LocalizedStringKey = "Self-levelling compound"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = .package
    
}

public class FloatingFloor: MaterialType {
    
    static var title: LocalizedStringKey = "Floating floor"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class SkirtingBoard: MaterialType {
    
    static var title: LocalizedStringKey = "Skirting board"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .basicMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class Silicone: MaterialType {
    
    static var title: LocalizedStringKey = "Silicone"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .basicMeter
    static var capacityUnity: UnitsOfMeasurment? = .package
    
}

public class Tiles: MaterialType {
    
    static var title: LocalizedStringKey = "Tiles"
    static var subTitle: LocalizedStringKey = "ceramicTiling"
    static var billSubTitle: LocalizedStringKey = "Tiles, ceramic"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class Pavings: MaterialType {
    
    static var title: LocalizedStringKey = "Pavings"
    static var subTitle: LocalizedStringKey = "ceramic"
    static var billSubTitle: LocalizedStringKey = "Pavings, ceramic"
    static var unit: UnitsOfMeasurment = .squareMeter
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class WindowMaterial: MaterialType {
    
    static var title: LocalizedStringKey = "Window"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .piece
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class DoorJamb: MaterialType {
    
    static var title: LocalizedStringKey = "Door jamb"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .piece
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}

public class AuxiliaryAndFasteningMaterial: MaterialType {
    
    static var title: LocalizedStringKey = "Auxiliary and fastening material"
    static var subTitle: LocalizedStringKey = ""
    static var unit: UnitsOfMeasurment = .percentage
    static var capacityUnity: UnitsOfMeasurment? = nil
    
}
