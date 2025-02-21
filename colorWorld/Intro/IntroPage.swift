//
//  IntroPage.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 13/02/25.
//

import SwiftUI

struct IntroPage: View {

    @Binding var showIntro: Bool
    @State private var selectedTab = 0

    init(showIntro: Binding<Bool>) {
        self._showIntro = showIntro
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.systemPink
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
    }

    private var bottomImageName: String {
        switch selectedTab {
        case 0:
            return "hi"
        case 1:
            return "heart"
        case 2:
            return "cute"
        default:
            return "hi"
        }
    }
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("ColorWorld")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .blue, .green, .yellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .blur(radius: 5)
                    .overlay(
                        Text("ColorWorld")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    )
                    .padding(.top, 40)
                Spacer()
            }
            .padding(.top, 20)

            Spacer()

            VStack {
                TabView(selection: $selectedTab) {
                    VStack(spacing: 30) {
                        Text("Hello Artist ♥️")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color(.black))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)

                        Text("We all have talent to build beautiful things through art, expressing our emotions and exploring our creativity")
                            .font(.title)
                            .foregroundColor(Color(.black))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 30)

                        Text("We can create art to express ourselves and let the mind speak through our fingers using shapes, color and even without words")
                            .font(.title)
                            .foregroundColor(Color(.black))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 30)
                    }
                    .tag(0)

                    VStack {

                        Text("From babies to adults, letting our creativity flow and expressing our mind, greatly improves our mental health, communication and well being.")
                            .font(.title)
                            .foregroundColor(Color(.black))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .padding(.bottom, 10)

                        Text("Colorworld aims to bring color (or change it) into our surroundings and our memories to truly show how we feel and see the world")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors:
                                    [ .green, .blue, .red]), startPoint: .leading, endPoint: .trailing)
                            )
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                }
                    .tag(1)
                   VStack {
                       Text("How to use it")
                           .font(.largeTitle.bold())
                           .foregroundColor(Color(.black))
                           .multilineTextAlignment(.center)
                           .padding(.bottom, 20)
                           .padding(.top, -30)

                       VStack(alignment: .leading, spacing: 10) {
                           HStack(spacing: 20) {
                               Image(systemName: "photo.fill.on.rectangle.fill")
                                   .font(.title)
                                   .foregroundColor(.blue)
                               Text("Upload or take a photo")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .multilineTextAlignment(.leading)
                           }
                           HStack(spacing: 20) {
                               Image(systemName: "paintpalette.fill")
                                   .font(.title)
                                   .foregroundColor(.green)
                               Text("Transform it into a drawing with Machine Learning")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .multilineTextAlignment(.leading)
                           }
                           HStack(spacing: 20) {
                               Image(systemName: "pencil.tip.crop.circle.badge.plus.fill")
                                   .font(.title)
                                   .foregroundColor(.orange)
                               Text("Add some color to it (with the Apple Pencil or your fingers) and save it")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .multilineTextAlignment(.leading)
                           }
                           HStack(spacing: 20) {
                               Image(systemName: "plus.square.fill")
                                   .font(.title)
                                   .foregroundColor(.purple)
                               Text("Save your art to your photo gallery and the app")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .multilineTextAlignment(.leading)
                           }
                           HStack(spacing: 20) {
                               Image(systemName: "star.fill")
                                   .font(.title)
                                   .foregroundColor(.pink)
                               Text("Continue editing and creating")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .multilineTextAlignment(.leading)
                           }
                           HStack(spacing: 20) {
                               Image(systemName: "lightbulb.fill")
                                   .font(.title)
                                   .foregroundColor(.yellow)
                               Text("Portrait orientation is recommended")
                                   .font(.title)
                                   .foregroundColor(.black)
                                   .multilineTextAlignment(.leading)
                           }
                           .padding(.bottom, 30)

                       }
                       .frame(maxWidth: .infinity, alignment: .leading)
                       Text("Let's go  🎨")
                           .font(.title)
                           .foregroundColor(.white)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(Color("rosa"))
                           .cornerRadius(10)
                           .onTapGesture {
                               showIntro = false
                           }
                           .frame(width: 200, height: 50, alignment: .center)
                   }
                   .padding(.horizontal)
               .tag(2)

                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.horizontal, 40)
            }
            .frame(width: 600, height: 650)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            Spacer()
            Image(bottomImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
    }
}

#Preview {
    @State var showIntro: Bool = true
    IntroPage(showIntro: $showIntro)
}
