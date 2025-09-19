//
//  TermView.swift
//  Karkonex
//
//  Created by QTS Coder on 12/11/24.
//

import SwiftUI

struct TermView: View {
    let isTerm: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        if isTerm{
            header
        }
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20, content: {
                Text("Privacy Policy").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 22)).multilineTextAlignment(.center)
                HStack{
                    Text("Information We Collect:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                
                VStack(spacing: 5, content: {
                    HStack{
                        Text("1.1. Personal Information:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("When you sign up for an account or use our services, we may collect personal information such as your name, email address, phone number, and location. This data is necessary to create and manage your account, facilitate communication with property owners/renters, and improve your overall experience.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                VStack(spacing: 5, content: {
                    HStack{
                        Text("1.2. Rental Preferences:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("To provide you with relevant rental options, we may collect information about your rental preferences, such as location, rental duration, and specific amenities you're looking for.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("1.3. Car Listings:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Car owners can submit rental listings that may contain information about their Car, including images, descriptions, and rental terms.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("1.4. Usage Data:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We may collect data on how you interact with our platform, including page views, clicks, search queries, and other activities, to analyze user behavior and improve our services.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                //
                HStack{
                    Text("How We Use Your Information:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("2.1. Personalization:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("The data we collect allows us to personalize your rental search experience by showing you relevant listings based on your preferences.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("2.2. Communication:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We use your contact information to facilitate communication between Car owners and renters, ensuring a seamless rental process.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("2.3. Improve Services:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("By analyzing user behavior, we can identify areas for improvement and enhance our website and app to better meet your needs.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("2.4. Legal Obligations:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We may use and disclose your information as required by law, such as responding to legal requests and protecting our rights and users' safety.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                HStack{
                    Text("Data Security:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("3.1. Encryption:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We employ industry-standard encryption and security measures to protect your data from unauthorized access or disclosure.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("3.2. Access Control:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Access to personal information is restricted to authorized personnel only, ensuring that your data remains confidential.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("3.3. Third-Party Services:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We work with reputable third-party service providers who also follow strict security protocols to process your data securely.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                //
                HStack{
                    Text("Sharing Your Information:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("4.1. Car Listings:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("When you create a rental listing as a Car owner, the information provided, excluding personal contact details, becomes accessible to potential renters.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("4.2. Communication:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Your contact information may be shared with other users (Car owners or renters) during the communication process to facilitate rental inquiries.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("4.3. Aggregated Data:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We may use aggregated and anonymized data for statistical analysis and marketing purposes, which does not identify individual users.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                HStack{
                    Text("Cookies and Tracking:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("5.1. Cookies: ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We use cookies and similar technologies to enhance your browsing experience, track user preferences, and gather usage data.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("5.2. Opt-Out:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("You can adjust your browser settings to disable cookies or be notified when they are being used. However, this may impact certain features and functionality on our platform.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                }) //
                HStack{
                    Text("Your Choices:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("6.1. Account Management:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("You can update your account information or delete your account at any time by accessing your account settings.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("6.2. Marketing Communications:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("You have the option to opt-out of receiving marketing communications from karkonnex.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                }) //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("Children's Privacy:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Karslist is not intended for use by individuals under the age of 18. We do not knowingly collect personal information from minors. If you believe a minor has provided us with their data, please contact us, and we will promptly remove the information from our records.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("Changes to the Privacy Policy:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("We may update this Privacy Policy periodically to reflect changes in our practices or legal requirements. We will notify you of any significant changes and seek your consent if required by applicable laws.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                }) //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("Contact Us:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("If you have any questions or concerns about our Privacy Policy or the use of your personal information, please contact us at privacy@Karslist.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("Last Updated: [Date]").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Free Research Preview. ChatGPT may produce inaccurate information about people, places, or facts. ChatGPT August 3 Version").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                }) //
               
               
            }).padding()
                .navigationBarHidden(true)
        }
    }
}
extension TermView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                
                Button {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Image("btnback")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
