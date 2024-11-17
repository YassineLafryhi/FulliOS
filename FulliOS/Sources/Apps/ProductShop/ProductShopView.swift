//
//  ProductShopView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 17/11/2024.
//

import PassKit
import SwiftUI

internal struct Product: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Decimal
    let image: String
}

internal class PaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(
        _: PKPaymentAuthorizationController,
        didAuthorizePayment _: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
    }
}

internal struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: product.image)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("$\(product.price)")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

internal struct ProductShopView: View {
    @State private var showingPaymentAlert = false
    let paymentHandler = PaymentHandler()

    let products = [
        Product(name: "Premium Widget", description: "High-quality digital widget", price: 9.99, image: "star.circle.fill"),
        Product(name: "Super Gadget", description: "Next-gen digital gadget", price: 19.99, image: "bolt.circle.fill"),
        Product(name: "Mega Bundle", description: "All-in-one digital package", price: 29.99, image: "gift.circle.fill")
    ]

    func buyProduct(_ product: Product) {
        let paymentNetwork: [PKPaymentNetwork] = [.masterCard, .visa]
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.yourcompany.yourapp"
        request.supportedNetworks = paymentNetwork
        request.merchantCapabilities = .threeDSecure
        request.countryCode = "US"
        request.currencyCode = "USD"

        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: product.name, amount: NSDecimalNumber(decimal: product.price))
        ]

        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller.delegate = paymentHandler
        controller.present { presented in
            if presented {
                print("Presented payment controller")
            } else {
                print("Failed to present payment controller")
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(products) { product in
                        ProductRow(product: product)
                            .padding(.horizontal)
                            .onTapGesture {
                                buyProduct(product)
                            }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Product Shop")
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
        }
        .alert(isPresented: $showingPaymentAlert) {
            Alert(
                title: Text("Thank You!"),
                message: Text("Your payment was successful."),
                dismissButton: .default(Text("OK")))
        }
    }
}
