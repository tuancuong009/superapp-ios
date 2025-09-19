//
//  DisclaimerView.swift
//  Karkonex
//
//  Created by QTS Coder on 12/11/24.
//

import SwiftUI
//
//  TermView.swift
//  Karkonex
//
//  Created by QTS Coder on 12/11/24.
//

import SwiftUI

struct DisclaimerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        header
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20, content: {
                Text("Disclaimer".uppercased()).font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 22)).multilineTextAlignment(.center)
                HStack{
                    Text("User Responsibility:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                
                VStack(spacing: 5, content: {
                    HStack{
                        Text("1.1. Rental Agreement:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com is solely a platform to connect renters and landlords. Users are responsible for conducting their due diligence and making informed decisions before entering into any rental agreement.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                VStack(spacing: 5, content: {
                    HStack{
                        Text("1.2. Verification:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex does not endorse or verify the accuracy of Car listings, rental terms, or the identity of users. It is the responsibility of renters and landlords to verify each other's information and authenticity.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("1.3. Rental Inspection:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Renters are encouraged to inspect Car thoroughly before making any commitments, ensuring that the Car meets their needs and expectations.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
               
                //
                HStack{
                    Text("No Liability for Damages:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("2.1. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com is not responsible for any damages, losses, or disputes arising from rental agreements between users on our platform. Users enter into rental agreements at their own risk.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("2.2. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com is not liable for any financial losses, physical damages, or personal injuries resulting from the use of our website or app.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("2.3. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com does not mediate or take any responsibility for disputes between renters and landlords, including but not limited to Car condition, rental payments, or lease violations.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
               
                
                HStack{
                    Text("Platform Services:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("3.1. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com is not a party to any rental transactions conducted through the platform. We do not provide rental or real estate services, and any agreements made between users are independent of karkonnex.com.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("3.2. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com does not guarantee the availability, accuracy, or suitability of any Car listings, rental rates, or Car amenities.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("3.3. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com reserves the right to modify, suspend, or discontinue any part of the platform's services without prior notice.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                //
                HStack{
                    Text("Third-Party Content:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("4.1. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com may contain links to third-party websites or services for informational purposes. These links do not imply our endorsement of those websites or their content. Users access third-party websites at their own risk.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
            
                //
                HStack{
                    Text("Use of Platform:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("5.1. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Users must comply with all applicable laws and regulations when using karkonnex.com. Any misuse of the platform or violation of our terms of service may result in the suspension or termination of a user's account.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
                //
                VStack(spacing: 5, content: {
                    HStack{
                        Text("5.2. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("Users must not engage in any fraudulent activities or attempt to deceive others through the platform.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                }) //
                HStack{
                    Text("Privacy:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("6.1. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com values user privacy and takes all reasonable measures to protect personal information. For more details, please refer to our Privacy Policy.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
               
                HStack{
                    Text("Indemnification:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("7.1. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("By using karkonnex.com, users agree to indemnify and hold karkonnex.com, its affiliates, officers, directors, employees, and agents harmless from any claims, liabilities, damages, expenses, and legal fees arising from their use of the platform or violation of this disclaimer.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
               
                HStack{
                    Text("Changes to the Disclaimer:").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                    Spacer()
                }
                VStack(spacing: 5, content: {
                    HStack{
                        Text("8.1. ").font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        Text("karkonnex.com may update this disclaimer as needed, and the most recent version will be posted on our website. Users are encouraged to review this disclaimer periodically.").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                })
               
            }).padding()
                .navigationBarHidden(true)
        }
    }
}
extension DisclaimerView {
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
#Preview {
    DisclaimerView()
}
