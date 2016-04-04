//
//  Localization.swift
//  Anyway
//
//  Created by Aviel Gross on 16/11/2015.
//  Copyright © 2015 Hasadna. All rights reserved.
//

import Foundation

/**
 Builds and gets a localized string for an enum
 type using the enum's name and the raw value.
 
 Format is:
 ENUM_NAME + "_" + RAW_VALUE
 
 e.g.,:
 SUG_YOM_1
 HUMRAT_TEUNA_9
 etc.

 For this to work any string using this
 enum must follow the above format...
 */
enum Localization {
    
    // Road Conditions
    case SUG_DERECH, YEHIDA, SUG_YOM, HUMRAT_TEUNA, SUG_TEUNA,
         ZURAT_DEREH, HAD_MASLUL, RAV_MASLUL, MEHIRUT_MUTERET,
         TKINUT, ROHAV, SIMUN_TIMRUR, TEURA, BAKARA, MEZEG_AVIR,
         PNE_KVISH, SUG_EZEM, MERHAK_EZEM, LO_HAZA, OFEN_HAZIYA,
         MEKOM_HAZIYA, KIVUN_HAZIYA, STATUS_IGUN
    
    // Vehicle Description
    case MATZAV_REHEV, SHIYUH_REHEV_LMS, SUG_REHEV_LMS
    
    // Involved Person Description
    case SUG_MEORAV, MIN, EMZAE_BETIHUT,
         HUMRAT_PGIA, SUG_NIFGA_LMS, PEULAT_NIFGA_LMS,
         PAZUA_USHPAZ, MADAD_RAFUI, YAAD_SHIHRUR,
         SHIMUSH_BE_AVIZAREY_BETIHOT, PTIRA_MEUHERET
    
    
    subscript(val: Int) -> String? {
        let localKey = "\(self)_\(val)"
        let result = local(localKey)
        
        // when no localized string found, we get
        // back the code we sent to 'local()'.
        // When this happens - pass an empty string
        // to the caller.
        return result.hasPrefix("\(self)") ? "" : result
    }
    
}


/**
 The supported app locals
 'rawValue' is the code used to
 set the local key in user defaults.
 */
enum AppLocal: String {
    case English = "en_US", Hebrew = "he_IL"
}

/**
 *  The app's language (i.e., local) is determined on
 *  launch (specifically in when initializing UIKit for
 *  the app) from the string in Apple's set user defaults
 *  key ("AppleLanguages").
 *  The workaround is to set that key before the app launces
 *  (i.e., in the 'main.swift' of the app). There is a bug
 *  where sometimes the local is determined after launch, so
 *  we override it in AppDelegate as well, just in case.
 */
struct ManualLocalizationWorker {
    
    
    /// Default for fresh install, or when there isn't any value
    private static var defaultLocal: AppLocal {
        let phoneVar = (defaults.objectForKey("AppleLanguages") as? [String])?
                        .flatMap{ AppLocal(rawValue: $0) }.first
        return phoneVar ?? AppLocal.English
    }
    
    /// The user preferenced local (saved in NSUserDefaults)
    private static let defaultsKey = "com.hasadna.anyway.AppLocal"
    static var defaults: NSUserDefaults { return NSUserDefaults.standardUserDefaults() }
    static var currentLocal: AppLocal {
        get{
            guard let
                rawVal = defaults.stringForKey(defaultsKey),
                local = AppLocal(rawValue: rawVal)
            else { return defaultLocal }
            return local
        }
        set{
            defaults.setObject(newValue.rawValue, forKey: defaultsKey)
            defaults.synchronize()
        }
    }
    
    /**
     Overrides the key for retreiving app local
     */
    static func overrideCurrentLocal() {
        let local = [currentLocal.rawValue]
        defaults.setObject(local, forKey: "AppleLanguages")
        defaults.synchronize()
    }
    
}



