//
//  InstallationOfSanitary+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 06/10/2023.
//
//


import CoreData
import SwiftUI

@objc(InstallationOfSanitary)
public class InstallationOfSanitary: NSManagedObject {
    
    static var generalTitle: LocalizedStringKey = "Sanitary installation"
    static var cornerValveSubTitle: LocalizedStringKey = "Corner valve"
    static var standingMixerTapSubTitle: LocalizedStringKey = "Standing mixer tap"
    static var wallMountedTapSubTitle: LocalizedStringKey = "Wall-mounted tap"
    static var flushMountedTapSubTitle: LocalizedStringKey = "Flush-mounted tap"
    static var toiletCombiSubTitle: LocalizedStringKey = "Toilet combi"
    static var toiletWtihConcealedCisternSubTitle: LocalizedStringKey = "Toilet with concealed cistern"
    static var sinkSubTitle: LocalizedStringKey = "Sink"
    static var sinkWithCabinetSubTitle: LocalizedStringKey = "Sink with cabinet"
    static var bathtubSubTitle: LocalizedStringKey = "Bathtub"
    static var showerCubicleSubTitle: LocalizedStringKey = "Shower cubicle"
    static var intallationOfGutterSubTitle: LocalizedStringKey = "Installation of gutter"
    static var urinal: LocalizedStringKey = "Urinal"
    static var bathScreen: LocalizedStringKey = "Bath screen"
    static var mirror: LocalizedStringKey = "Mirror"
    
    static var unit: UnitsOfMeasurement = .piece
    
}
