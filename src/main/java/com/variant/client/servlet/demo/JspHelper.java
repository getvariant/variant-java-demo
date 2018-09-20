package com.variant.client.servlet.demo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.variant.client.StateRequest;
import com.variant.client.servlet.VariantFilter;
import com.variant.core.StateRequestStatus;
import com.variant.core.schema.Test;

/**
 * Static helper methods to be called from JSPs.
 */
public class JspHelper {

    Logger log = LoggerFactory.getLogger(JspHelper.class);

    //private final HttpServletRequest request;
	private final HttpServletResponse response;
	private final StateRequest stateRequest;
	
	public JspHelper(HttpServletRequest request, HttpServletResponse response) {
		//this.request = request;
		this.response = response;
        stateRequest = (StateRequest) request.getAttribute(VariantFilter.VARIANT_REQUEST_ATTR_NAME);
	}
	
	/**
	 * Is there there a given live experience?
	 * All exceptions are caught and appropriately processed.
	 */
	public boolean isLiveExperienceInTest(String testName, String expName) {
		
		// We won't have the state request if no Variant server.
        if (stateRequest != null) {
           
	        // If we're on an instrumented page, VariantFilter has put current Variant state request in HTTP request.
	        try {
	              
	    	    Test test = stateRequest.getSession().getSchema().getTest(testName);
	        	Test.Experience exp = stateRequest.getLiveExperience(test);
	        	// exp will be null if this variation is turned off.
				return exp != null && expName.equals(exp.getName());
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
