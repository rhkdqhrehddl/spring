package com.pg.spring;

import java.util.Base64.Encoder;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;

import java.util.Map;


import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.GsonBuilder;

@Controller
@RequestMapping("/TossPG")
public class TossPGController {
	
	@Value("${clientKey}")
	private String clientKey;

	@Value("${secretKey}")
	private String secretKey;
	
	
	@PostConstruct
	public void postConstruct() {
		Encoder encoder = java.util.Base64.getEncoder();
		
		secretKey = secretKey + ":";
		secretKey = new String(encoder.encode(secretKey.getBytes()));
	}
	
	
	@RequestMapping(value = "**/key.do", method = RequestMethod.POST)
	public @ResponseBody String key(@RequestParam (value="kind", required=true, defaultValue="clientKey")String kind) {
		return kind.equals("clientKey") ? clientKey : secretKey;
	}
	
	@RequestMapping(value = "**/success.do", method = RequestMethod.GET)
	public String success(Model model, @RequestParam (value="paymentKey", required=true) String paymentKey, 
			PayRequest payRequest) {
		try {
			HttpClient client = HttpClientBuilder.create().build(); 
			HttpPost postRequest = new HttpPost("https://api.tosspayments.com/v1/payments/" + paymentKey); 
			
			postRequest.setHeader("Accept", "application/json;charset=UTF-8");
			postRequest.setHeader("Authorization", "Basic "+ secretKey);
			postRequest.setHeader("Content-Type", "application/json;charset=UTF-8");
			
			String jsonStr = new GsonBuilder().create().toJson(payRequest);
			
			postRequest.setEntity(new StringEntity(jsonStr));
						
			HttpResponse response = client.execute(postRequest);
			model.addAttribute("resp_code", response.getStatusLine().getStatusCode());
			model.addAttribute("requestFlag", 1);

			//Response
			if (response.getStatusLine().getStatusCode() == 200) {
				ResponseHandler<String> handler = new BasicResponseHandler();
				ObjectMapper mapper = new ObjectMapper();
				
				String body = handler.handleResponse(response);
				System.out.println(body);

				Map<String, String> map = mapper.readValue(body, Map.class);
				model.addAttribute("result", map);
			} else {
				String err_msg = EntityUtils.toString(response.getEntity());
				System.out.println("response is error : " + err_msg);
				model.addAttribute("err_msg", err_msg);
			}

		} catch (Exception e){
			model.addAttribute("err_msg", e.toString());
			return "/TossPG/error";
		}
		
		return "/TossPG/success";
	}
	
	
	
	@RequestMapping(value = "**/Cancel.do", method = RequestMethod.POST)
	public String cancel(Model model, @RequestParam (value="paymentKey", required=true) String paymentKey, 
			CancelRequest cancelRequest) {
		try {			
			HttpClient client = HttpClientBuilder.create().build(); 
			HttpPost postRequest = new HttpPost("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel"); 
			
			postRequest.setHeader("Accept", "application/json;charset=UTF-8");
			postRequest.setHeader("Authorization", "Basic "+ secretKey);
			postRequest.setHeader("Content-Type", "application/json;charset=UTF-8");
			
			String jsonStr = new GsonBuilder().create().toJson(cancelRequest);
			
			postRequest.setEntity(new StringEntity(jsonStr));
						
			HttpResponse response = client.execute(postRequest);
			model.addAttribute("resp_code", response.getStatusLine().getStatusCode());
			model.addAttribute("requestFlag", 2);

			//Response
			if (response.getStatusLine().getStatusCode() == 200) {
				ResponseHandler<String> handler = new BasicResponseHandler();
				ObjectMapper mapper = new ObjectMapper();
				
				String body = handler.handleResponse(response);
				System.out.println(body);

				Map<String, String> map = mapper.readValue(body, Map.class);
				model.addAttribute("result", map);
			} else {
				String err_msg = EntityUtils.toString(response.getEntity());
				System.out.println("response is error : " + err_msg);
				model.addAttribute("err_msg", err_msg);
			}

		} catch (Exception e){
			model.addAttribute("err_msg", e.toString());
			return "/TossPG/error";
		}
		
		return "/TossPG/success";
	}
	
	@RequestMapping(value = "**/Search.do", method = RequestMethod.GET)
	public String search(Model model, @RequestParam (value="paymentKey", required=true) String paymentKey) {
		try {
			HttpClient client = HttpClientBuilder.create().build(); 
			HttpGet getRequest = new HttpGet("https://api.tosspayments.com/v1/payments/" + paymentKey); 
			
			getRequest.setHeader("Accept", "application/json;charset=UTF-8");
			getRequest.setHeader("Authorization", "Basic "+ secretKey);
			getRequest.setHeader("Content-Type", "application/json;charset=UTF-8");
						
			HttpResponse response = client.execute(getRequest);
			model.addAttribute("resp_code", response.getStatusLine().getStatusCode());
			model.addAttribute("requestFlag", 3);

			//Response
			if (response.getStatusLine().getStatusCode() == 200) {
				ResponseHandler<String> handler = new BasicResponseHandler();
				ObjectMapper mapper = new ObjectMapper();
				
				String body = handler.handleResponse(response);
				System.out.println(body);

				Map<String, String> map = mapper.readValue(body, Map.class);
				model.addAttribute("result", map);
			} else {
				String err_msg = EntityUtils.toString(response.getEntity());
				System.out.println("response is error : " + err_msg);
				model.addAttribute("err_msg", err_msg);
			}

		} catch (Exception e){
			model.addAttribute("err_msg", e.toString());
			return "/TossPG/error";
		}
		
		return "/TossPG/success";
	}
	
	
	@RequestMapping(value = "**/callback.do", method = RequestMethod.POST)
	public String callback() {
		return "/TossPG/callback";
	}
	
	@RequestMapping(value = "**/billingKey.do", method = RequestMethod.GET)
	public String billingKey(Model model, @RequestParam (value="customerKey", required=true) String customerKey, 
			@RequestParam (value="authKey", required=true) String authKey) {
		try {
			HttpClient client = HttpClientBuilder.create().build(); 
			HttpPost postRequest = new HttpPost("https://api.tosspayments.com/v1/billing/authorizations/" + authKey); 
			
			postRequest.setHeader("Accept", "application/json;charset=UTF-8");
			postRequest.setHeader("Authorization", "Basic "+ secretKey);
			postRequest.setHeader("Content-Type", "application/json;charset=UTF-8");
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("customerKey", customerKey);
			
			String jsonStr = new GsonBuilder().create().toJson(jsonObject);
			
			postRequest.setEntity(new StringEntity(jsonStr));
						
			HttpResponse response = client.execute(postRequest);
			model.addAttribute("resp_code", response.getStatusLine().getStatusCode());
			model.addAttribute("requestFlag", 4);

			//Response
			if (response.getStatusLine().getStatusCode() == 200) {
				ResponseHandler<String> handler = new BasicResponseHandler();
				ObjectMapper mapper = new ObjectMapper();
				
				String body = handler.handleResponse(response);
				System.out.println(body);

				Map<String, String> map = mapper.readValue(body, Map.class);
				model.addAttribute("result", map);
			} else {
				String err_msg = EntityUtils.toString(response.getEntity());
				System.out.println("response is error : " + err_msg);
				model.addAttribute("err_msg", err_msg);
			}

		} catch (Exception e){
			model.addAttribute("err_msg", e.toString());
			return "/TossPG/error";
		}
		
		return "/TossPG/success";
	}
	
	
	@RequestMapping(value = "**/Billing.do", method = RequestMethod.POST)
	public String Billing(Model model, @RequestParam (value="billingKey", required=true) String billingKey, 
			BillingRequest billingRequest) {
		try {			
			HttpClient client = HttpClientBuilder.create().build(); 
			HttpPost postRequest = new HttpPost("https://api.tosspayments.com/v1/billing/" + billingKey); 
			
			postRequest.setHeader("Accept", "application/json;charset=UTF-8");
			postRequest.setHeader("Authorization", "Basic "+ secretKey);
			postRequest.setHeader("Content-Type", "application/json;charset=UTF-8");
			
			String jsonStr = new GsonBuilder().create().toJson(billingRequest);
			
			postRequest.setEntity(new StringEntity(jsonStr));
						
			HttpResponse response = client.execute(postRequest);
			model.addAttribute("resp_code", response.getStatusLine().getStatusCode());
			model.addAttribute("requestFlag", 5);

			//Response
			if (response.getStatusLine().getStatusCode() == 200) {
				ResponseHandler<String> handler = new BasicResponseHandler();
				ObjectMapper mapper = new ObjectMapper();
				
				String body = handler.handleResponse(response);
				System.out.println(body);

				Map<String, String> map = mapper.readValue(body, Map.class);
				model.addAttribute("result", map);
			} else {
				String err_msg = EntityUtils.toString(response.getEntity());
				System.out.println("response is error : " + err_msg);
				model.addAttribute("err_msg", err_msg);
			}

		} catch (Exception e){
			model.addAttribute("err_msg", e.toString());
			return "/TossPG/error";
		}
		
		return "/TossPG/success";
	}
	
	
	@RequestMapping(value = "**/fail.do", method = RequestMethod.GET)
	public String fail(HttpServletRequest request) {
		return "/TossPG/fail";
	}	
}