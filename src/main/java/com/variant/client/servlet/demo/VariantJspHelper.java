package com.variant.client.servlet.demo;

import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.variant.client.StateRequest;
import com.variant.client.servlet.VariantFilter;
import com.variant.core.StateRequestStatus;
import com.variant.core.schema.Variation.Experience;

/**
 * Static helper methods to be called from JSPs.
 */
public class VariantJspHelper {

    Logger log = LoggerFactory.getLogger(VariantJspHelper.class);

    //private final HttpServletRequest request;
	private final HttpServletResponse response;
	private final StateRequest stateRequest;
	
	public VariantJspHelper(HttpServletRequest request, HttpServletResponse response) {
        // If we're on an instrumented page, VariantFilter has put current Variant state request in HTTP request.
        stateRequest = (StateRequest) request.getAttribute(VariantFilter.VARIANT_REQUEST_ATTR_NAME);
		this.response = response;
	}
	
	/**
	 * Get the live experience in a given variation by name.
	 * All exceptions are caught and appropriately logged.
	 */
	public Optional<String> getLiveExperienceInVariation(String testName) {
		
		// We won't have the state request if no Variant server.
        if (stateRequest != null) {
	        try {	              
	        	for (Experience e: stateRequest.getLiveExperiences()) {
	        		if (e.getVariation().getName().equals(testName)) return Optional.of(e.getName());
	        	}
	        	        	
	        	return Optional.empty();
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
        return Optional.empty();
	}
	
	/**
	 * 
	 */
	public void failRequest() {
		if (stateRequest != null && stateRequest.getStatus() == StateRequestStatus.InProgress)
			stateRequest.fail(response);
	}
}
