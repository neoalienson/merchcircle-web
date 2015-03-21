package com.instastore.mvc;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

/**
 * Created by lsiu on 3/21/2015.
 */

@Controller
@RequestMapping("/product")
@Slf4j
public class ProductController {
	
	private Map<String, Product> database = new HashMap<>();

    @RequestMapping("{id}")
    public ModelAndView view(@PathVariable("id") String productId) {

        Product product = database.get(productId);
        if (product == null) {
        	return new ModelAndView("error/404");
        } else {
        	return new ModelAndView("product/view", "product", product);
        }
    }
    
    @RequestMapping(method=RequestMethod.POST)
    public ResponseEntity<String> newProduct(@RequestBody Product product) {
    	log.debug("Product: {}", product);
    	database.put(product.getId(), product);
    	return ResponseEntity.ok("Succcess");
    }
 
    @RequestMapping(value="image/{id}", method=RequestMethod.GET, produces = "image/png")
    public ResponseEntity<?> image(@PathVariable String id) {
    	log.debug("Get image for product id:'{}'", id);
    	Product product = database.get(id);
    	if (product == null) {
    		return ResponseEntity.notFound().build();
    	} else {
	    	return ResponseEntity.ok().contentType(MediaType.parseMediaType("image/png"))
	    			.body(Base64.getDecoder().decode(product.getImage()));
    	}
    }
    
}