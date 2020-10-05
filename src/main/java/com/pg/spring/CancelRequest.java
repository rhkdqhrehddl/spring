package com.pg.spring;

public class CancelRequest {
	private String cancelReason;
	private String cancelAmount;
	private String requesterType;
	
	public String getCancelReason() {
		return cancelReason;
	}
	public void setCancelReason(String cancelReason) {
		this.cancelReason = cancelReason;
	}
	public String getCancelAmount() {
		return cancelAmount;
	}
	public void setCancelAmount(String cancelAmount) {
		this.cancelAmount = cancelAmount;
	}
	public String getRequesterType() {
		return requesterType;
	}
	public void setRequesterType(String requesterType) {
		this.requesterType = requesterType;
	}
}
