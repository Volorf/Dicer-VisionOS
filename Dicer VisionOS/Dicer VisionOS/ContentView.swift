//
//  ContentView.swift
//  Dicer VisionOS
//
//  Created by Oleg Frolov on 23/07/2023.
//

import SwiftUI
import RealityKit

struct ContentView: View
{
    @State var showImmersiveSpace = false
    @State var angle: Double = 90.0
    @State var isPressed: Bool = false
    @State var zOffset: Double = 0
    @State var buttonScale: Double = 1.0
    
    let scale: SIMD3<Float> = [0.25, 0.25, 0.25]
    
    func randAngle()
    {
        if (Bool.random())
        {
            angle += 360.0 + 90 * Double.random(in: 1...4).rounded()
        }
        else
        {
            angle -= 360 + 90 * Double.random(in: 1...4).rounded()
        }
    }
    
    var body: some View
    {
        VStack
        {
            RealityView { content in
                
                async let diceBody = ModelEntity(named: "Dice_Body")
                async let dots1 = ModelEntity(named: "Dots1")
                async let dots2 = ModelEntity(named: "Dots2")
                async let dots3 = ModelEntity(named: "Dots3")
                async let dots4 = ModelEntity(named: "Dots4")
                async let dots5 = ModelEntity(named: "Dots5")
                async let dots6 = ModelEntity(named: "Dots6")
                
                if let diceBody = try? await diceBody,
                   let dots3 = try? await dots3,
                   let dots1 = try? await dots1,
                   let dots2 = try? await dots2,
                   let dots4 = try? await dots4,
                   let dots5 = try? await dots5,
                   let dots6 = try? await dots6
                {
                    
                    
                    diceBody.transform.scale = scale
                    dots3.transform.scale = scale
                    dots1.transform.scale = scale
                    dots2.transform.scale = scale
                    dots4.transform.scale = scale
                    dots5.transform.scale = scale
                    dots6.transform.scale = scale
  
                    content.add(diceBody)
                    content.add(dots3)
                    content.add(dots1)
                    content.add(dots2)
                    content.add(dots4)
                    content.add(dots5)
                    content.add(dots6)
                }
            }
            .rotation3DEffect(.degrees(angle), axis: Bool.random() ? (0.0, 1.0, 0.0) : (0.1, 0.0, 0.0))
            .animation(.bouncy(duration: 1.0), value: angle)
            .padding3D(.front, zOffset)
            .animation(.bouncy(duration: 1.0), value: zOffset)
            .onTapGesture
            {
                randAngle()
            }
            
            Text("Roll the Dice")
                .font(.system(size: 24))
            .frame(width: 240, height: 100)
            .glassBackgroundEffect()
            .hoverEffect(.highlight)
            .scaleEffect(buttonScale)
            .animation(.bouncy(duration: 0.5), value: buttonScale)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    
                    if (!isPressed)
                    {
                        randAngle()
                        zOffset = -400.0
                        buttonScale = 0.9
                        print("Down")
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    if (isPressed)
                    {
                        zOffset = 0
                        buttonScale = 1.0
                        print("Up")
                        isPressed = false
                    }
                })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
