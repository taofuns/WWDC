//
//  PlayerView.swift
//  WWDC
//
//  Created by Leon on 7/18/23.
//

import SwiftUI
import AVKit

struct PlayerView: View {

    let url: URL


    var body: some View {
        VStack {

            let player = AVPlayer(url: url)
            VideoPlayer(player: player)
                .onAppear {
                    print(player.status)
                }
        }
    }
}


//#Preview {
//    PlayerView()
//}
