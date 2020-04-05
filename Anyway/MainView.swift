//
//  MainView.swift
//  Anyway
//
//  Created by Liat Grinshpun on 04/04/2020.
//  Copyright © 2020 Hasadna. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        AccidentsMapView().edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
