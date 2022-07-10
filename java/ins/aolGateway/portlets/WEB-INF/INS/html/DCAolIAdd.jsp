<%-- load WPS portlet tag library and initialize objects --%>
<%@ page import="com.ibm.pvc.we.ins.portlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ taglib uri="/WEB-INF/tld/portlet.tld" prefix="portletAPI" %>
<portletAPI:init />
<%

DeliveryChannelBean dcBean = (DeliveryChannelBean)portletRequest.getAttribute("dcBean");
String nls = (String)portletRequest.getAttribute(DeliveryChannelBaseController.NLS_BLUDLE_ATTRIBUTE);
String defaultUserId = "";
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

// set up array of time choices for delay time drop boxes
DateFormat timeFormat = DateFormat.getTimeInstance(DateFormat.SHORT, portletRequest.getLocale());
DateFormat timeCodeFormat = new SimpleDateFormat("HHmm", Locale.US);
Calendar cal = new GregorianCalendar(1977, 6, 9, 0, 0);  // date portion not used, only time portion
int numberOfTimeChoices = 48;
Calendar timeChoices[] = new Calendar[numberOfTimeChoices];

for(int i = 0; i < numberOfTimeChoices; i++)
{
    timeChoices[i] = (Calendar)cal.clone();
    cal.add(Calendar.MINUTE,(int)(1440/numberOfTimeChoices));
}
%>

<form name="<portletAPI:encodeNamespace value="DC_EDIT"/>" action="<%= request.getAttribute("saveURI") %>" method="POST">
<table cellspacing="4" cellpadding="0" border="0" width="100%">
        <tr>
            <td>
                <input type="image" name="<portletAPI:encodeNamespace value='edit_done'/>" value="edit_done" src='<%= portletResponse.encodeURL("/images/INS/header_ok.gif")%>' align="absmiddle" alt="<portletAPI:text key="dcBase.ok" bundle="<%= nls %>"/>" border="0">
                <A href="javascript:document.<portletAPI:encodeNamespace value="DC_EDIT"/>.action.value='edit_done.x';document.<portletAPI:encodeNamespace value="DC_EDIT"/>.submit();" STYLE="text-decoration:none">
                    &nbsp;<span class="wpsTaskIconText"><portletAPI:text key="dcBase.ok" bundle="<%= nls %>"/></SPAN>&nbsp;
                </A>
                <IMG src='<%= portletResponse.encodeURL("/images/INS/header_divider.gif")%>' align="absmiddle" border="0" alt="">
                <input type="image" name="<portletAPI:encodeNamespace value='cancel'/>" value="cancel" src='<%= portletResponse.encodeURL("/images/INS/header_cancel.gif")%>' align="absmiddle" alt="<portletAPI:text key="dcBase.cancel" bundle="<%= nls %>"/>" border="0">
                <A href="javascript:window.location.href='<%= portletResponse.createURI() %>'" STYLE="text-decoration:none">
                    &nbsp;<span class="wpsTaskIconText"><portletAPI:text key="dcBase.cancel" bundle="<%= nls %>"/></SPAN>
                </A>
                <%if(modifyMode)
                {%>
                <IMG src='<%= portletResponse.encodeURL("/images/INS/header_divider.gif")%>' align="absmiddle" border="0" alt="">
                <input type="image" name="<portletAPI:encodeNamespace value='delete'/>" value="delete" src='<%= portletResponse.encodeURL("/images/INS/delete_box.gif")%>' align="absmiddle" alt="<portletAPI:text key="dcBase.delete_dc" bundle="<%= nls %>"/>" border="0">
                <A href="javascript:document.<portletAPI:encodeNamespace value="DC_EDIT"/>.action.value='delete.x';document.<portletAPI:encodeNamespace value="DC_EDIT"/>.submit();" STYLE="text-decoration:none">
                    &nbsp;<span class="wpsTaskIconText"><portletAPI:text key="dcBase.delete_dc" bundle="<%= nls %>"/></SPAN>&nbsp;
                </A>
              <%}
                %>
            </td>
        </tr>
        <tr>
            <td colspan="2" height="1" class="wpsAdminHeadSeparator"><IMG src='<%= portletResponse.encodeURL("/images/INS/dot.gif")%>' align="absmiddle" border="0" alt="" height="1"></td>
        </tr>
    </table>
    <INPUT type="hidden" VALUE="" name="action">

<%
 // error text
 if (errorId != null) { %>
<img src='<%= portletResponse.encodeURL("/images/INS/error.gif")%>' border="0">
&nbsp;<span class="wpsFieldErrorText"><portletAPI:text key="<%=errorId%>" bundle="<%= nls %>"/></span>
<% } %>

    <!-- begin field table -->
    <table border="0" width="100%">
        <%if(modifyMode)
        {%>
        <tr>
            <td class="wpsLabelText">
                <IMG src='<%= portletResponse.encodeURL("/images/INS/information.gif")%>' BORDER="0" alt="">
                <SPAN class="wpsInlineHelpText"><portletAPI:text key="dcAol.modify_text" bundle="<%= nls %>"/>&nbsp;<%= dcBean.getNameLocalized(portletRequest.getLocale())%></SPAN>
                <INPUT type="hidden" VALUE="<%= dcBean.getName()%>" name="<portletAPI:encodeNamespace value="dcName"/>">
            </td>
        </tr>
      <%}
        else
        {
        %>
        <tr>
            <td class="wpsLabelText">
                <span class="wpsLabelText"><label for="<portletAPI:encodeNamespace value="dcName"/>"><portletAPI:text key="dcBase.dc_name_label" bundle="<%= nls %>"/></label></span>
                <br>
                <input type="text" id="<portletAPI:encodeNamespace value="dcName"/>"name="<portletAPI:encodeNamespace value="dcName"/>" value="<%=defaultDcName%>">
            </td>
        </tr>
        <%
        }
        %>
        <tr>
            <td class="wpsLabelText">
                <span class="wpsLabelText"><label for="<portletAPI:encodeNamespace value="userid"/>"><portletAPI:text key="dcAolIMGW.st_id_label" bundle="<%= nls %>"/></label></span>
                <br>
                <input type="text" id="<portletAPI:encodeNamespace value="userid"/>" name="<portletAPI:encodeNamespace value="userid"/>" value="<%=defaultUserId%>">
            </td>
        </tr>
        <%-- stop delivery section --%>
        <tr>
            <td class="wpsLabelText">
                <span class="wpsLabelText"><label for="<portletAPI:encodeNamespace value="userid"/>"><portletAPI:text key="dcBase.stop_delivery_label" bundle="<%= nls %>"/></label></span>
            </td>
        </tr>
        <tr>
            <td class="wpsLabelText">
                <IMG src='<%= portletResponse.encodeURL("/images/INS/information.gif")%>' BORDER="0" alt="">
                <SPAN class="wpsInlineHelpText"><portletAPI:text key="dcBase.stop_delivery_help" bundle="<%= nls %>"/></SPAN>
            </td>
        </tr>
        <tr>
        <td>
            <table border="0">
            <tr>
                <td>
                <label for="<portletAPI:encodeNamespace value='fromTime'/>"><portletAPI:text key="dcBase.start_time_label" bundle="<%= nls %>"/></label>
                </td>
                <td>
                </td>
                <td>
                <label for="<portletAPI:encodeNamespace value='toTime'/>"><portletAPI:text key="dcBase.stop_time_label" bundle="<%= nls %>"/></label>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td class="wpsLabelText">
                    <select name="<portletAPI:encodeNamespace value='fromTime'/>" id="<portletAPI:encodeNamespace value='fromTime'/>">
                        <%
                        for(int i = 0; i < numberOfTimeChoices; i++)
                        {
                            Date date = timeChoices[i].getTime();
                            %>
                            <option value="<%= timeCodeFormat.format(date)%>"><%= timeFormat.format(date)%></option>
                            <%
                        }
                        %>
                    </select>
                </td>
                <td class="wpsLabelText">
                    <portletAPI:text key="dcBase.to" bundle="<%= nls %>"/>
                </td>
                <td class="wpsLabelText">
                    <select name="<portletAPI:encodeNamespace value='toTime'/>" id="<portletAPI:encodeNamespace value='toTime'/>">
                        <%
                        for(int i = 0; i < numberOfTimeChoices; i++)
                        {
                            Date date = timeChoices[(i+1)%numberOfTimeChoices].getTime();
                            %>
                            <option value="<%= timeCodeFormat.format(date)%>"><%= timeFormat.format(date)%></option>
                            <%
                        }
                        %>
                    </select>
                </td>
                <td class="wpsLabelText" align="left">
                    <input type="image" name="<portletAPI:encodeNamespace value='addDelay'/>" value="addDelay" src='<%= portletResponse.encodeURL("/images/INS/add.gif")%>' align="absmiddle" title="<portletAPI:text key="dcBase.add_time_period" bundle="<%= nls %>"/>" alt="<portletAPI:text key="dcBase.add_time_period" bundle="<%= nls %>"/>" border="0">
                    <A href="javascript:document.<portletAPI:encodeNamespace value="DC_EDIT"/>.action.value='addDelay.x';document.<portletAPI:encodeNamespace value="DC_EDIT"/>.submit();" STYLE="text-decoration:none">
                        &nbsp;<span class="wpsDialogIconText"><portletAPI:text key="dcBase.add_time_period" bundle="<%= nls %>"/></SPAN>&nbsp;
                    </A>
                </td>
            </tr>
            <tr>
                <td colspan="3" class="wpsLabelText">
                <label for="<portletAPI:encodeNamespace value="selectedDelayTime"/>"><portletAPI:text key="dcBase.time_periods_list_label" bundle="<%= nls %>"/></label>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <select name="<portletAPI:encodeNamespace value="selectedDelayTime"/>" id="<portletAPI:encodeNamespace value="selectedDelayTime"/>" SIZE="6" width="100%" style="width:100%;">
                    <%
                     if(delayTimes != null)
                     {
                        Enumeration e = delayTimes.elements();
                        for(int i = 0; e.hasMoreElements(); i++)
                        {
                           TimeRange time = (TimeRange)e.nextElement();
                           %>

                          <option value="<%= String.valueOf(i)%>"><%=time.to12HourString(portletRequest.getLocale())%></option>

                        <%
                        }
                     }
                      %>
                    </select>
                    <%
                     if(delayTimes != null)
                     {
                        Enumeration e = delayTimes.elements();
                        for(int i = 1; e.hasMoreElements(); i++)
                        {
                           TimeRange time = (TimeRange)e.nextElement();
                           %>

                          <input type="hidden" name="<%=portletResponse.encodeNamespace("delayTime" + String.valueOf(i))%>" value="<%=time.toString(Locale.US)%>">

                        <%
                        }
                     }
                      %>
                </td>
                <td class="wpsLabelText" VALIGN="TOP" align="left">
                    <input type="image" name="<portletAPI:encodeNamespace value='deleteDelay'/>" value="deleteDelay"  src='<%= portletResponse.encodeURL("/images/INS/delete.gif")%>' align="top" title="<portletAPI:text key="dcBase.delete_time_period" bundle="<%= nls %>"/>" alt="<portletAPI:text key="dcBase.delete_time_period" bundle="<%= nls %>"/>" border="0">
                    <A href="javascript:document.<portletAPI:encodeNamespace value="DC_EDIT"/>.action.value='deleteDelay.x';document.<portletAPI:encodeNamespace value="DC_EDIT"/>.submit();" STYLE="text-decoration:none">
                        &nbsp;<span class="wpsDialogIconText"><portletAPI:text key="dcBase.delete_time_period" bundle="<%= nls %>"/></SPAN>&nbsp;
                    </A>
                </td>
            </tr>
            </table>
        </td>
        </tr>

    </table>
    <%-- end field table --%>


    <table cellspacing="4" cellpadding="0" border="0" width="100%">
        <tr>
            <td height="1" class="wpsAdminHeadSeparator"><img src='<%= portletResponse.encodeURL("/images/INS/dot.gif")%>' align="absmiddle" border="0" alt="" height="1"></td>
        </tr>
        <tr>
            <td>
                <input type="image" name="<portletAPI:encodeNamespace value='edit_done'/>" value="edit_done" src='<%= portletResponse.encodeURL("/images/INS/header_ok.gif")%>' align="absmiddle" alt="<portletAPI:text key="dcBase.ok" bundle="<%= nls %>"/>" border="0">
                <A href="javascript:document.<portletAPI:encodeNamespace value="DC_EDIT"/>.action.value='edit_done.x';document.<portletAPI:encodeNamespace value="DC_EDIT"/>.submit();" STYLE="text-decoration:none">
                    &nbsp;<span class="wpsTaskIconText"><portletAPI:text key="dcBase.ok" bundle="<%= nls %>"/></SPAN>&nbsp;
                </A>
                <IMG src='<%= portletResponse.encodeURL("/images/INS/header_divider.gif")%>' align="absmiddle" border="0" alt="">
                <input type="image" name="<portletAPI:encodeNamespace value='cancel'/>" value="cancel" src='<%= portletResponse.encodeURL("/images/INS/header_cancel.gif")%>' align="absmiddle" alt="<portletAPI:text key="dcBase.cancel" bundle="<%= nls %>"/>" border="0">
                <A href="javascript:window.location.href='<%= portletResponse.createURI() %>'" STYLE="text-decoration:none">
                    &nbsp;<span class="wpsTaskIconText"><portletAPI:text key="dcBase.cancel" bundle="<%= nls %>"/></SPAN>
                </A>
                <%if(modifyMode)
                {%>
                <IMG src='<%= portletResponse.encodeURL("/images/INS/header_divider.gif")%>' align="absmiddle" border="0" alt="">
                <input type="image" name="<portletAPI:encodeNamespace value='delete'/>" value="delete" src='<%= portletResponse.encodeURL("/images/INS/delete_box.gif")%>' align="absmiddle" alt="<portletAPI:text key="dcBase.delete_dc" bundle="<%= nls %>"/>" border="0">
                <A href="javascript:document.<portletAPI:encodeNamespace value="DC_EDIT"/>.action.value='delete.x';document.<portletAPI:encodeNamespace value="DC_EDIT"/>.submit();" STYLE="text-decoration:none">
                    &nbsp;<span class="wpsTaskIconText"><portletAPI:text key="dcBase.delete_dc" bundle="<%= nls %>"/></SPAN>&nbsp;
                </A>
              <%}
                %>
            </td>
        </tr>
    </table>
</form>

