<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!--
PetClinic :: a Spring Framework demonstration
-->

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>PetClinic :: a Spring Framework demonstration</title>


    <spring:url value="/webjars/bootstrap/2.3.0/css/bootstrap.min.css" var="bootstrapCss"/>
    <link href="${bootstrapCss}" rel="stylesheet"/>

    <spring:url value="/resources/css/petclinic.css" var="petclinicCss"/>
    <link href="${petclinicCss}" rel="stylesheet"/>

    <spring:url value="/webjars/jquery/2.0.3/jquery.js" var="jQuery"/>
    <script src="${jQuery}"></script>

	<!-- jquery-ui.js file is really big so we only load what we need instead of loading everything -->
    <spring:url value="/webjars/jquery-ui/1.10.3/ui/jquery.ui.core.js" var="jQueryUiCore"/>
    <script src="${jQueryUiCore}"></script>

	<spring:url value="/webjars/jquery-ui/1.10.3/ui/jquery.ui.datepicker.js" var="jQueryUiDatePicker"/>
    <script src="${jQueryUiDatePicker}"></script>
    
    <!-- jquery-ui.css file is not that big so we can afford to load it -->
    <spring:url value="/webjars/jquery-ui/1.10.3/themes/base/jquery-ui.css" var="jQueryUiCss"/>
    <link href="${jQueryUiCss}" rel="stylesheet"></link>
    
    <%-- --------------------------------------------------------------------------- --%>
    <%--                             Variant Demo start                              --%>
    <%-- --------------------------------------------------------------------------- --%>
    
    <script src="http://getvariant.com/js/variant-0.9.0.js"></script>

    <%@ page import="com.variant.client.StateRequest" %>
    <%@ page import="com.variant.client.Session" %>
    <%@ page import="com.variant.client.servlet.VariantFilter" %>
    <%
        // If we're on an instrumented page PetclinicVariantFilter has put current Variant state request in HTTP request.
        StateRequest stateRequest = (StateRequest) request.getAttribute(VariantFilter.VARIANT_REQUEST_ATTR_NAME);
        if (stateRequest != null) {
        	Session varSession = stateRequest.getSession();
    %>

	    <script>
	        var variantSession = null;
	        // Open a connection to Variant server.
	        variant.connect(
	        	"variant:localhost:5377/variant:petclinic",
	        	function(conn) {
        	       // Fetch existing Variant session.
			       conn.getSessionById(
			       	  "<%=varSession.getId()%>",
			          function(session) {
			             variantSession = session;
			          }
			       );
			    }
		    );

			// onSubmit listener sends the CLICK event.	        	   
			$(document).ready(function() {   
	   			$(':submit').click(function() {
	   			variantSession.triggerEvent(new variant.Event("CLICK", $(this).html()));   
	  		 });
		});
	    </script>

    <% } %>    

    <%-- --------------------------------------------------------------------------- --%>
    <%--                              Variant Demo end                               --%>
    <%-- --------------------------------------------------------------------------- --%>
     
</head>


