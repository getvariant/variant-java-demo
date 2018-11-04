<!DOCTYPE html> 

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>

<%@ page import="java.util.Optional" %>
<%@ page import="com.variant.core.schema.Variation.Experience" %>
<%@ page import="com.variant.client.servlet.demo.VariantJspHelper" %>

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
              
    <%
	   if ("rateColumn".equals(request.getAttribute("hourlyRateExperience"))) {
    %>
    
        <datatables:column title="Hourly Rate">
                <c:out value="${vet.rate}"/>
        </datatables:column>
    
    
    <% } %>
    
    
    
    
    <%
       VariantJspHelper helper2 = new VariantJspHelper(request, response);
       Optional<String> liveExperienceName2 = helper2.getLiveExperienceInVariation("ScheduleVisitTest");
       
       try {
           
	       if (liveExperienceName2.isPresent() && liveExperienceName2.get().equals("withLink")) {
	       
    %>
    
              <datatables:column title="Availability">
                <a href="/petclinic/owners/11/pets/14/visits/new/?vet=<c:out value="${vet.firstName}+${vet.lastName}"></c:out>">Schedule an appt</a>
        </datatables:column>
    
    
    <%      
              }
           }
           catch (Exception e) {
              helper2.failRequest();   
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
