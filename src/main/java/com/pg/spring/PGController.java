package com.pg.spring;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/PG")
public class PGController {	
	@RequestMapping(value = "/XPayClient/*.do", method = RequestMethod.POST)
	public String XPayClient(HttpServletRequest request) {
		System.out.print("");
		String[] aa = request.getServletPath().split("[.]");
		return request.getServletPath().split("[.]")[0];
	}

	@RequestMapping(value = "/SmartXPay/*.do", method = RequestMethod.POST)
	public String SmartXPay(HttpServletRequest request) {
		System.out.print("");
		String[] aa = request.getServletPath().split("[.]");
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/MobileAuthOnly/*.do", method = RequestMethod.POST)
	public String MobileAuthOnly(HttpServletRequest request) {
		System.out.print("");
		String[] aa = request.getServletPath().split("[.]");
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/CardBilling/*.do", method = RequestMethod.POST)
	public String CardBilling(HttpServletRequest request) {
		System.out.print("");
		String[] aa = request.getServletPath().split("[.]");
		return request.getServletPath().split("[.]")[0];
	}
}
