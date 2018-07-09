<!DOCTYPE html> 

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="en">
<jsp:include page="fragments/staticFiles.jsp"/>

    <%-- --------------------------------------------------------------------------- --%>
    <%--                             Variant Demo start                              --%>
    <%-- --------------------------------------------------------------------------- --%>
    
    <%@ page import="com.variant.core.StateRequestStatus" %>
    <%@ page import="com.variant.client.StateRequest" %>
    <%@ page import="com.variant.client.Session" %>
    <%@ page import="com.variant.client.servlet.demo.VariantFilter" %>
    <%
        // If we're on an instrumented page PetclinicVariantFilter has put current Variant state request in HTTP request.
        StateRequest stateRequest = (StateRequest) request.getAttribute(VariantFilter.VARIANT_REQUEST_ATTR_NAME);
        if (stateRequest != null) {
			stateRequest.setStatus(StateRequestStatus.FAIL);
			stateRequest.getSession().setAttribute("ViewAsJsonFix", "true");
			stateRequest.commit(response);
        } 
    %>    

    <%-- --------------------------------------------------------------------------- --%>
    <%--                              Variant Demo end                               --%>
    <%-- --------------------------------------------------------------------------- --%>

<body>
<div class="container">
    <jsp:include page="fragments/bodyHeader.jsp"/>
    <spring:url value="/resources/images/pets.png" var="petsImage"/>
    <img src="${petsImage}"/>

    <h2>Something happened...</h2>

    <p>${exception.message}</p>

    <!-- Exception: ${exception.message}.
		  	<c:forEach items="${exception.stackTrace}" var="stackTrace"> 
				${stackTrace} 
			</c:forEach>
	  	-->


    <jsp:include page="fragments/footer.jsp"/>

</div>
</body>

</html>
