//
//  Account.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 30.03.22.
//

import Foundation

struct Account: Codable {
    let createdAt, accountID, firstname: String
    let lastname: String?
    let email: String
    let phone, address, billingAddress, billingEmail: String?
    let billingName, billingVat: String?
    let mode: String
    let depositID, clientID, accountNumber, ibanBrokerage: String?
    let ibanOrigin, bankNameOrigin: String?
    let balance, cashToInvest, cashToWithdraw, amountBoughtIntraday: Int
    let amountSoldIntraday, amountOpenOrders, amountOpenWithdrawals, amountEstimateTaxes: Int
    let approvedAt: Date?
    let tradingPlan, dataPlan: String
    let taxAllowance, taxAllowanceStart, taxAllowanceEnd: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case accountID = "account_id"
        case firstname, lastname, email, phone, address
        case billingAddress = "billing_address"
        case billingEmail = "billing_email"
        case billingName = "billing_name"
        case billingVat = "billing_vat"
        case mode
        case depositID = "deposit_id"
        case clientID = "client_id"
        case accountNumber = "account_number"
        case ibanBrokerage = "iban_brokerage"
        case ibanOrigin = "iban_origin"
        case bankNameOrigin = "bank_name_origin"
        case balance
        case cashToInvest = "cash_to_invest"
        case cashToWithdraw = "cash_to_withdraw"
        case amountBoughtIntraday = "amount_bought_intraday"
        case amountSoldIntraday = "amount_sold_intraday"
        case amountOpenOrders = "amount_open_orders"
        case amountOpenWithdrawals = "amount_open_withdrawals"
        case amountEstimateTaxes = "amount_estimate_taxes"
        case approvedAt = "approved_at"
        case tradingPlan = "trading_plan"
        case dataPlan = "data_plan"
        case taxAllowance = "tax_allowance"
        case taxAllowanceStart = "tax_allowance_start"
        case taxAllowanceEnd = "tax_allowance_end"
    }
}
