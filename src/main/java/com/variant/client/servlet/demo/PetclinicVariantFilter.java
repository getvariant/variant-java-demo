package com.variant.client.servlet.demo;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import com.variant.client.servlet.ServletSession;
import com.variant.client.servlet.VariantFilter;

public class PetclinicVariantFilter extends VariantFilter { 
	
	/**
	 * Add the user agent header to the session. It's used in some of the demo hooks.
	 */
	@Override
	protected void onSession(ServletRequest request, ServletResponse response, ServletSession ssn) {
		ssn.getAttributes().put("user-agent", ((HttpServletRequest)request).getHeader("User-Agent"));
	}
}
