<!DOCTYPE html> 

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>

<html lang="en">


<jsp:include page="../fragments/staticFiles.jsp"/>

<body>
<div class="container">
    <jsp:include page="../fragments/bodyHeader.jsp"/>

    <h2>Veterinarians</h2>

    <datatables:table id="vets" data="${vets.vetList}" row="vet" theme="bootstrap2" cssClass="table table-striped" pageable="false" info="false">
        <datatables:column title="Name">
            <c:out value="${vet.firstName} ${vet.lastName}"></c:out>
        </datatables:column>
        
        <datatables:column title="Specialties">
            <c:forEach var="specialty" items="${vet.specialties}">
                <c:out value="${specialty.name}"/>
            </c:forEach>
            <c:if test="${vet.nrOfSpecialties == 0}">none</c:if>
        </datatables:column>
      
    <%@ page import="org.slf4j.*" %>
    <%@ page import="com.variant.core.schema.*" %>
    <%@ page import="com.variant.client.*" %>
    <%@ page import="com.variant.client.servlet.VariantFilter" %>
        
    <%
        // We may need a logger.
        Logger log = LoggerFactory.getLogger("vetList.jsp");
        StateRequest stateRequest = (StateRequest) request.getAttribute(VariantFilter.VARIANT_REQUEST_ATTR_NAME);

		// We won't have the state request when the toggle is off.
        if (stateRequest != null) {
           
	        // If we're on an instrumented page, VariantFilter has put current Variant state request in HTTP request.
	        try {
	              
	    	    Test test = stateRequest.getSession().getSchema().getTest("VetsHourlyRateFeature");
	        	Test.Experience exp = stateRequest.getLiveExperience(test);
				if ("rateColumn".equals(exp.getName())) {
				
				// We're in the new feature - show the hourly rate column
    %>
    
        <datatables:column title="Hourly Rate">
                <c:out value="${vet.rate}"/>
        </datatables:column>
    
    
    <% 
	           }
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
    %>
    
    </datatables:table>
    
    <table class="table-buttons">
        <tr>
            <td>
                <a href="<spring:url value="/vets.xml" htmlEscape="true" />">View as XML</a>
            </td>
            <td>
                <a href="<spring:url value="/vets.json" htmlEscape="true" />">View as JSon</a>
            </td>
        </tr>
    </table>

    <jsp:include page="../fragments/footer.jsp"/>
</div>
</body>

</html>
