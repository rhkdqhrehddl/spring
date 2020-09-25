package com.pg.spring;

import java.util.Base64.Encoder;
import java.util.Map;


import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.GsonBuilder;

@Controller
@RequestMapping("/TossPG")
public class TossPGController {
	@RequestMapping(value = "**/success.do", method = RequestMethod.GET)
	public String success(Model model, @RequestParam (value="paymentKey", required=true) String paymentKey, 
			PayRequest payRequest) {
		try {
			Encoder encoder = java.util.Base64.getEncoder();
			String secretKey = "test_ak_YZ1aOwX7K8mjBX1WdK93yQxzvNPG" + ":";
			secretKey = new String(encoder.encode(secretKey.getBytes()));
			
			HttpClient client = HttpClientBuilder.create().build(); 
			HttpPost postRequest = new HttpPost("https://api.tosspayments.com/v1/payments/" + paymentKey); 
			
			postRequest.setHeader("Accept", "application/json;charset=UTF-8");
			postRequest.setHeader("Authorization", "Basic "+ secretKey);
			postRequest.setHeader("Content-Type", "application/json;charset=UTF-8");
			
			String jsonStr = new GsonBuilder().create().toJson(payRequest);
			
			postRequest.setEntity(new StringEntity(jsonStr));
						
			HttpResponse response = client.execute(postRequest);
			model.addAttribute("resp_code", response.getStatusLine().getStatusCode());

			//Response
			if (response.getStatusLine().getStatusCode() == 200) {
				ResponseHandler<String> handler = new BasicResponseHandler();
				ObjectMapper mapper = new ObjectMapper();
				
				String body = handler.handleResponse(response);
				System.out.println(body);

				Map<String, String> map = mapper.readValue(body, Map.class);
				model.addAttribute("result", map);
			} else {
				System.out.println("response is error : " + response.getStatusLine().getStatusCode());
				model.addAttribute("err_msg", response.getStatusLine().getReasonPhrase());
			}

		} catch (Exception e){
			model.addAttribute("err_msg", e.toString());
			return "/TossPG/error";
		}
		
		return "/TossPG/success";
	}
}