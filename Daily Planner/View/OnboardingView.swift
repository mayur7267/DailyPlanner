//
//  OnboardingView.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//
import SwiftUI

// MARK: - Onboarding View
struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    @State private var animatePage = false
    @EnvironmentObject var taskManager: TaskManager
    
    private let onboardingData = [
        OnboardingPage(
            title: "Plan smarter\nAccomplish more\nStress-free",
            subtitle: "Transform your daily chaos into organized productivity",
            image: "calendar.circle.fill",
            color: .accentPurple
        ),
        OnboardingPage(
            title: "Get a clear picture\nof your day",
            subtitle: "See all your tasks and appointments in one beautiful timeline",
            image: "clock.arrow.circlepath",
            color: .accentBlue
        ),
        OnboardingPage(
            title: "Don't pile up tasks\nComplete them",
            subtitle: "Smart scheduling helps you tackle tasks at the right time",
            image: "checkmark.circle.fill",
            color: .accentGreen
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.backgroundPrimary, .backgroundSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingData[index], animate: animatePage)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentPage) { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        animatePage.toggle()
                    }
                }
                
                VStack(spacing: 30) {
                    
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingData.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? onboardingData[currentPage].color : Color.gray.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                                .accessibilityLabel(currentPage == index ? "Current page \(index + 1)" : "Page \(index + 1)")
                        }
                    }
                    .padding(.top, 20)
                    
                  
                    HStack(spacing: 20) {
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                hasSeenOnboarding = true
                            }
                        }) {
                            Text("Skip")
                                .font(.system(.body, design: .rounded, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                )
                        }
                        .accessibilityLabel("Skip onboarding")
                        
                       
                        Button(action: {
                            if currentPage < onboardingData.count - 1 {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentPage += 1
                                    animatePage.toggle()
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    hasSeenOnboarding = true
                                }
                            }
                        }) {
                            Text(currentPage < onboardingData.count - 1 ? "Next" : "Start Planning")
                                .font(.system(.title3, design: .rounded, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(onboardingData[currentPage].color)
                                        .shadow(color: onboardingData[currentPage].color.opacity(0.3), radius: 8, x: 0, y: 4)
                                )
                        }
                        .accessibilityLabel(currentPage < onboardingData.count - 1 ? "Next page" : "Start planning")
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                animatePage = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let animate: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            
            ZStack {
                Circle()
                    .fill(Color.cardBackground)
                    .frame(width: 140, height: 140)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animate)
                
                Image(systemName: page.image)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(animate ? 1.0 : 0.7)
                    .opacity(animate ? 1.0 : 0.3)
                    .animation(.easeInOut(duration: 0.5).delay(0.1), value: animate)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Illustration for \(page.title)")
            
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animate ? 1.0 : 0.0)
                    .offset(y: animate ? 0 : 20)
                    .animation(.easeInOut(duration: 0.5).delay(0.2), value: animate)
                    .dynamicTypeSize(.xLarge) 
                
                Text(page.subtitle)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .opacity(animate ? 1.0 : 0.0)
                    .offset(y: animate ? 0 : 20)
                    .animation(.easeInOut(duration: 0.5).delay(0.3), value: animate)
                    .dynamicTypeSize(.large)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
