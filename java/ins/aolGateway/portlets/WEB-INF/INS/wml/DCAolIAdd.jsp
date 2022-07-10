<%-- load WPS portlet tag library and initialize objects --%>
<%@ page import="com.ibm.pvc.we.ins.portlets.*" %>
<%@ page import="java.util.*" %>

<%@ taglib uri="/WEB-INF/tld/portlet.tld" prefix="portletAPI" %>
<portletAPI:init />
<%

DeliveryChannelBean dcBean = (DeliveryChannelBean)portletRequest.getAttribute("dcBean");
String nls = (String)portletRequest.getAttribute(DeliveryChannelBaseController.NLS_BLUDLE_ATTRIBUTE);
String defaultUserId = "";
String defaultPassword = "";
String defaultDcName = "";
Vector delayTimes = null;
String modeParam = (String)portletRequest.getAttribute(DeliveryChannelBaseController.MODE_KEY);
String errorId = (String)portletRequest.getAttribute("errorId");
boolean modifyMode = false;

if((modeParam != null) && (DeliveryChannelBaseController.MODIFY_MODE_PARAMETER.equals(modeParam)))
{
   modifyMode = true;
}

if(dcBean != null)
{
   defaultDcName = (String)dcBean.getNameLocalized(portletRequest.getLocale());
   if(defaultDcName == null)
   {
      defaultDcName = "";
   }
   defaultUserId = (String)dcBean.getProperty("ibm-appdeviceaddress");
   if(defaultUserId == null)
   {
      defaultUserId = "";
   }
   defaultPassword = (String)dcBean.getProperty("ibm-undAolpassword");
   if(defaultPassword == null)
   {
      defaultPassword = "";
   }

   TimeRange[] delayTimesArr = dcBean.getDelayTimeRanges();

   if(delayTimesArr != null)
   {
      delayTimes = new Vector(delayTimesArr.length);
      for(int i = 0; i < delayTimesArr.length; i++)
      {
         delayTimes.add(delayTimesArr[i]);
      }
   }
}
%>

<do type="accept" label="<portletAPI:text key="msgPr.ok" bundle="<%= nls %>"/>">
    <go href="<%= request.getAttribute("saveURI") %>">
        <postfield name="<portletAPI:encodeNamespace value='edit_done.x'/>" value="true"/>
        <%if(modifyMode)
         {%>
        <postfield name="<portletAPI:encodeNamespace value='dcName'/>" value="<%= dcBean.getName()%>"/>
        <%} else {
          %>
        <postfield name="<portletAPI:encodeNamespace value='dcName'/>" value="$(dcName)"/>
      <% }
         if(delayTimes != null)
         {
            Enumeration e = delayTimes.elements();
            for(int i = 1; e.hasMoreElements(); i++)
            {
               TimeRange time = (TimeRange)e.nextElement();
               %>
              <postfield name="<%=portletResponse.encodeNamespace("delayTime" + String.valueOf(i))%>" value="<%=time.toString()%>"/>
            <%
            }
         }
          %>
        <postfield name="<portletAPI:encodeNamespace value='userid'/>" value="$(userid)"/>
    </go>
</do>

<do type="reset" label="<portletAPI:text key="msgPr.cancel" bundle="<%= nls %>"/>">
    <go href="<%= portletResponse.createURI() %>"/>
</do>

<%if(modifyMode)
{%>
<do type="accept" label="<portletAPI:text key="dcBase.delete_dc" bundle="<%= nls %>"/>">
    <go href="<%= request.getAttribute("saveURI") %>">
        <postfield name="<portletAPI:encodeNamespace value='delete.x'/>" value="true"/>
        <postfield name="<portletAPI:encodeNamespace value='dcName'/>" value="<%= dcBean.getName()%>"/>
    </go>
</do>
<%}
 // error text
 if (errorId != null) { %>
<p><strong><portletAPI:text key="<%=errorId%>" bundle="<%= nls %>"/></strong></p>
<% } %>
<p>
<%if(modifyMode)
{%>
<portletAPI:text key="dcAol.modify_text" bundle="<%= nls %>"/>&nbsp;<%= dcBean.getNameLocalized(portletRequest.getLocale())%><br />
<%}
else
{
%>
<em><portletAPI:text key="dcBase.dc_name_label" bundle="<%= nls %>"/></em><br />
<input name="dcName" value="<%=defaultDcName%>" /><br />
<%
}
%>
<em><portletAPI:text key="dcAol.st_id_label" bundle="<%= nls %>"/></em><br />
<input name="userid" value="<%=defaultUserId%>" /><br />
</p>
<%if(modifyMode) // only list the delay times in modify mode, since they are view only
{%>
<p>
   <em><portletAPI:text key="dcBase.stop_delivery_times" bundle="<%= nls %>"/></em><br />
   <%
   if(delayTimes != null)
   {
      Enumeration e = delayTimes.elements();
      for(int i = 0; e.hasMoreElements(); i++)
      {
         TimeRange time = (TimeRange)e.nextElement();
         %>

        <%=time.to12HourString()%><br />

      <%
      }
   }
   else
   { %>
   <portletAPI:text key="dcBase.no_stop_delivery_times_set" bundle="<%= nls %>"/><br />
   <%
   }%>
</p>
<%
}
%>

