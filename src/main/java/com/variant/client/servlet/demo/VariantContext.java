package com.variant.client.servlet.demo;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.WebApplicationInitializer;

import com.variant.client.ConfigKeys;
import com.variant.client.Connection;
import com.variant.client.Session;
import com.variant.client.VariantException;
import com.variant.client.servlet.ServletVariantClient;

public class VariantContext implements WebApplicationInitializer {

	private static final Logger LOG = LoggerFactory.getLogger(VariantContext.class);
	private static final ServletVariantClient client = ServletVariantClient.Factory.getInstance();
	private static final String schemaName = "petclinic";
	
	private static Connection conn;
	
	public ServletVariantClient getClient() {
		return client;
	}
	
	/**
	 * Called once by Spring container.
	 */
	@Override
	public void onStartup(ServletContext context) throws ServletException {
		connect();
	}

	/**
	 * Get connection. If it is null, try to reconnect.
	 * @return
	 */
	public static Session getSession(HttpServletRequest request) {
		if (conn == null) {
			if (LOG.isDebugEnabled()) LOG.debug("Attempting to reconnect to Variant schema [" + schemaName + "]");
			connect();
		}
		return conn == null ? null : conn.getOrCreateSession(request); 
	}
	
	/**
	 * Try to connect to the remote schema.
	 */
	private static void connect() {
		try {
			conn = client.connectTo(schemaName);
			if (conn == null) {
				LOG.error(
						"Variation schema [" + schemaName + "] does not exist on " + 
						client.getConfig().getString(ConfigKeys.SERVER_URL));
			}
			else {
				LOG.info("Connected to Variant schema [" + schemaName + "]");
			}
		}
		catch (VariantException vex) {
			LOG.error(
					"Failed to connect to Variant server at " + 
					client.getConfig().getString(ConfigKeys.SERVER_URL), vex);
		}		
	}
 }