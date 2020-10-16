package com.pg.spring;

public class BillingRequest {
	private String amount;
	private String customerEmail;
	private String customerKey;
	private String customerPhone;
	private String orderId;
	private String orderName;
	private String taxFreeAmount;
	
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getCustomerEmail() {
		return customerEmail;
	}
	public void setCustomerEmail(String customerEmail) {
		this.customerEmail = customerEmail;
	}
	public String getCustomerKey() {
		return customerKey;
	}
	public void setCustomerKey(String customerKey) {
		this.customerKey = customerKey;
	}
	public String getCustomerPhone() {
		return customerPhone;
	}
	public void setCustomerPhone(String customerPhone) {
		this.customerPhone = customerPhone;
	}
	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public String getOrderName() {
		return orderName;
	}
	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}
	public String getTaxFreeAmount() {
		return taxFreeAmount;
	}
	public void setTaxFreeAmount(String taxFreeAmount) {
		this.taxFreeAmount = taxFreeAmount;
	}
}
