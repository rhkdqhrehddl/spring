package com.pg.spring;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/PG")
public class PGController {
	private String mb_noSession_cst_platform = null;
	private String mb_noSession_cst_mid = null;
	
	@RequestMapping(value = "/XPayClient/*.do", method = RequestMethod.POST)
	public String XPayClient(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}

	@RequestMapping(value = "/SmartXPay/*.do", method = RequestMethod.POST)
	public String SmartXPay(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/MobileAuthOnly/*.do", method = RequestMethod.POST)
	public String MobileAuthOnly(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/CardBilling/*.do", method = RequestMethod.POST)
	public String CardBilling(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/SmartXPayBilling/*.do", method = RequestMethod.POST)
	public String SmartXPayBilling(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	
	@RequestMapping(value = "/SmartXPayEasyPay/*.do", method = RequestMethod.POST)
	public String SmartXPayEasyPay(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/CardMobileXPay/*.do", method = RequestMethod.POST)
	public String CardMobileXPay(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "**/cancel_url.do", method = RequestMethod.GET)
	public String CancelURL(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/MobileNoSession/*.do", method = RequestMethod.POST)
	public String MobileNoSession(Model model, HttpServletRequest request) throws UnsupportedEncodingException {
		request.setCharacterEncoding("utf-8");
		String path = request.getServletPath().split("[.]")[0];
		
		if(path.contains("payreq")) {
			mb_noSession_cst_platform = request.getParameter("CST_PLATFORM");
			mb_noSession_cst_mid = request.getParameter("CST_MID");
		} else if(path.contains("payres")) {
			model.addAttribute("CST_PLATFORM", mb_noSession_cst_platform);
			model.addAttribute("CST_MID", mb_noSession_cst_mid);
		}
		return path;
	}
	
	@RequestMapping(value = "/AuthOnly/*.do", method = RequestMethod.POST)
	public String AuthOnly(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/NoSession/*.do", method = RequestMethod.POST)
	public String NoSession(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/CardAPI/*.do", method = RequestMethod.POST)
	public String CardAPI(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/PartialCancel/*.do", method = RequestMethod.POST)
	public String PartialCancel(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/AccCert/*.do", method = RequestMethod.POST)
	public String AccCert(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/CardApp/*.do", method = RequestMethod.POST)
	public String CardApp(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/GiftCulture/*.do", method = RequestMethod.POST)
	public String GiftCulture(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/Escrow/*.do")
	public String Escrow(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}

	@RequestMapping(value = "/OpenPay/*.do")
	public String OpenPay(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/RegisterMert/*.do")
	public String RegisterMert(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	

	@RequestMapping(value = "/EasyPay/*.do", method = RequestMethod.POST)
	public String EasyPay(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
	
	@RequestMapping(value = "/AnsimKeyin/*.do")
	public String AnsimKeyin(HttpServletRequest request) {
		return request.getServletPath().split("[.]")[0];
	}
}