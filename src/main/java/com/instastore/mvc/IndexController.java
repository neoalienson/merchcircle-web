package com.instastore.mvc;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/")
@Controller
public class IndexController {
	
	@RequestMapping
	public String index() {
		return "index/view";
	}

}