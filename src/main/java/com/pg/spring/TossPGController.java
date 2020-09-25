package com.pg.spring;

import java.util.Base64.Encoder;

import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.GsonBuilder;

@Controller
@RequestMapping("/TossPG")
public class TossPGController {
	@RequestMapping(value = "**/success.do", method = RequestMethod.GET)
	public String success(Model model, @RequestParam (value="paymentKey", required=true) String paymentKey, 
			PayRequest payRequest) {
		try {
			Encoder encoder = java.util.Base64.getEncoder();
			String secretKey = ":" + "test_ak_ODnyRpQWGrNDAXmpdW23Kwv1M9EN";
			secretKey = new String(encoder.encode(secretKey.getBytes()));
			
			HttpClient client = HttpClientBuilder.create().build(); 
			HttpPost postRequest = new HttpPost("https://api.tosspayments.com/v1/payments/" + paymentKey); 
			
			postRequest.addHeader("Authorization", secretKey);
			postRequest.addHeader("Content-Type", "application/json");
			
			String jsonStr = new GsonBuilder().create().toJson(payRequest);
			
			postRequest.setEntity(new StringEntity(jsonStr));
						
			HttpResponse response = client.execute(postRequest);

			//Response
			if (response.getStatusLine().getStatusCode() == 200) {
				ResponseHandler<String> handler = new BasicResponseHandler();
				String body = handler.handleResponse(response);
				System.out.println(body);
				model.addAttribute("result", EntityUtils.toString(response.getEntity(), "UTF-8"));
			} else {
				System.out.println("response is error : " + response.getStatusLine().getStatusCode());
				model.addAttribute("result", response.getStatusLine().getStatusCode() + response.getStatusLine().getReasonPhrase());
			}

		} catch (Exception e){
			System.err.println(e.toString());
		}
		
		return "/TossPG/success";
	}
}