package com.variant.client.servlet.demo;

import java.util.concurrent.atomic.AtomicBoolean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.variant.client.StateRequest;
import com.variant.client.servlet.VariantFilter;
import com.variant.core.StateRequestStatus;

/**
 * Static helper methods to be called from JSPs.
 */
public class JspHelper {

    Logger log = LoggerFactory.getLogger(JspHelper.class);

    //private final HttpServletRequest request;
	private final HttpServletResponse response;
	private final StateRequest stateRequest;
	
	public JspHelper(HttpServletRequest request, HttpServletResponse response) {
        // If we're on an instrumented page, VariantFilter has put current Variant state request in HTTP request.
        stateRequest = (StateRequest) request.getAttribute(VariantFilter.VARIANT_REQUEST_ATTR_NAME);
		this.response = response;
	}
	
	/**
	 * Is there there a given live experience?
	 * All exceptions are caught and appropriately processed.
	 */
	public boolean isLiveExperienceInTest(String testName, String expName) {
		
		// Emulating closure with a boxed mutable.
		AtomicBoolean result = new AtomicBoolean(false);
		
		// We won't have the state request if no Variant server.
        if (stateRequest != null) {
           
	        try {	              
	        	stateRequest.getSession().getSchema().getVariation(testName).ifPresent(
	        		variation -> result.set(variation.getExperience(expName).isPresent())
	        	);
	        	        	
	        	return result.get();
	        } 
	    	catch (Exception e) {
	    	 	
	    	 	// Something amiss with Variant instrumentation.
	    	 	// Try to fail current request, if any.
	    	 	try {
					stateRequest.fail(response);
	    	 		log.error("Variant threw unexpected exception", e); 
	    	 	}
	    	 	catch (Exception e2) {
	    	 		log.error("Variant threw unexpected exception", e2); 
	    	 	}
	    	}
	    }
        return false;
	}
	
	/**
	 * 
	 */
	public void failRequest() {
		if (stateRequest != null && stateRequest.getStatus() == StateRequestStatus.InProgress)
			stateRequest.fail(response);
	}
}
