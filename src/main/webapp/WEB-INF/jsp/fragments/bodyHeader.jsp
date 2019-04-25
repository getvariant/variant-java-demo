<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<spring:url value="/resources/images/banner-graphic.png" var="banner"/>
<img src="${banner}"/>

<div class="navbar" style="width: 601px;">
    <div class="navbar-inner">
        <ul class="nav">
            <li style="width: 90px;"><a href="<spring:url value="/" htmlEscape="true" />"><i class="icon-home"></i>
                Home</a></li>
            <li style="width: 130px;"><a href="<spring:url value="/owners/find.html" htmlEscape="true" />"><i
                    class="icon-search"></i> Find owners</a></li>
            <li style="width: 130px;"><a href="<spring:url value="/vets.html" htmlEscape="true" />"><i
                    class="icon-th-list"></i> Veterinarians</a></li>
            <li style="width: 90px;"><a href="<spring:url value="/oups.html" htmlEscape="true" />"
                                        title="trigger a RuntimeException to see how it is handled"><i
                    class="icon-warning-sign"></i> Error</a></li>

            <%--   Variant Demo start --%>
            <% 
                // Everyone is John Kennedy, unless selects otherwise.
                if (session.getAttribute("user") == null) session.setAttribute("user", "John Kennedy");
            %>
            <li style="width: 90px;">
              <form action="<spring:url value="/owners/login.html" htmlEscape="true" />" method="GET">
	              <select name="user" style="width: 130px; margin-top: 4px;" onchange="this.form.submit();"> 
	                <option value="John Kennedy" <%= "John Kennedy".equals(session.getAttribute("user")) ? "selected" : ""  %>>John Kennedy</option>
	                <option value="Nikita Krushchev" <%= "Nikita Krushchev".equals(session.getAttribute("user")) ? "selected" : ""  %>>Nikita Krushchev</option>
			      </select> 
            	</form>
            </li>
            <%--   Variant Demo end --%>
            
        </ul>
    </div>
</div>
	
