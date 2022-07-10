package com.ibm.pvc.we.ins.portlets;

// Java libraries
import java.util.*;
import java.io.*;
import java.text.*;

// Portlet API classes
import org.apache.jetspeed.portlet.*;
import org.apache.jetspeed.portlet.event.*;
import org.apache.jetspeed.portlets.*;

// WPS portlet helper classes
//import com.ibm.wps.portlets.util.*;
import com.ibm.wps.portlets.*;

import com.ibm.pvc.ent.style.*;

/**
 * The <TT>AolDeliveryChannelController</TT> class provides a template to controll the content
 * display and portlet configuration behavior of the delivery channel portlets.<BR />
 */
public class AolDeliveryChannelController extends DeliveryChannelBaseController implements ActionListener
{
    private final static String COPYRIGHT = "Sample Delivery Channel";

    /**
     *
     * @param request(org.apache.jetspeed.portlet.PortletRequest)
     * Current portlet request
     * @param response(org.apache.jetspeed.portlet.PortletResponse)
     * Current portlet response
     * @exception org.apache.jetspeed.portlet.PortletException
     * Exception thrown by this method
     * @exception java.io.IOException
     * Exception thrown by this method
     */
    public void doAdd ( PortletRequest request,
                        PortletResponse response) throws PortletException, IOException
    {
        // trace information
        PortletLog log = getPortletLog();
        if (getPortletLog().isDebugEnabled())
        {
            getPortletLog().debug("AolDeliveryChannelController(doAdd): " +
                                  "entering doAdd()...");
        }

        // create action uri for add
        PortletURI saveUri = response.createURI();
        saveUri.addAction(new DefaultPortletAction("add"));
        request.setAttribute("saveURI", saveUri);

        // put the add "attribute" on the request
        request.setAttribute(MODE_KEY, ADD_MODE_PARAMETER);

        // include JSP for extended search
        getPortletConfig().getContext().include(StyleBean.style("/WEB-INF/INS/DCAolAdd.jsp", request, getPortletConfig().getContext()), request, response);
    }

    /**
     *
     * @param request(org.apache.jetspeed.portlet.PortletRequest)
     * Current portlet request
     * @param response(org.apache.jetspeed.portlet.PortletResponse)
     * Current portlet response
     * @exception org.apache.jetspeed.portlet.PortletException
     * Exception thrown by this method
     * @exception java.io.IOException
     * Exception thrown by this method
     */
    public void doModify ( PortletRequest request,
                           PortletResponse response) throws PortletException, IOException
    {
        // trace information
        PortletLog log = getPortletLog();
        if (getPortletLog().isDebugEnabled())
        {
            getPortletLog().debug("AolDeliveryChannelController(doModify): " +
                                  "entering doModify()...");
        }

        if (request.getAttribute("dcBean") == null)
        {
            // the bean has not already been put on the request by actionPerformed
            String dcName = request.getParameter(DC_NAME_PARAMETER);

            DeliveryChannelBean dcBean = getDeliveryChannelFromSessionList(request, dcName);

            if (dcBean != null)
            {
                if (getPortletLog().isDebugEnabled()) getPortletLog().debug("AolDeliveryChannelController(doModify): got bean " + dcBean.getName());
                request.setAttribute("dcBean", dcBean);
            }
            else
            {
                if (getPortletLog().isDebugEnabled()) getPortletLog().debug("AolDeliveryChannelController(doModify): bean by name " + dcName + " is null");
            }
        }

        // create action uri for add
        PortletURI saveUri = response.createURI();
        saveUri.addAction(new DefaultPortletAction("modify"));
        request.setAttribute("saveURI", saveUri);

        // put the modify "attribute" on the request
        request.setAttribute(MODE_KEY, MODIFY_MODE_PARAMETER);

        // include JSP for extended search
        getPortletConfig().getContext().include(StyleBean.style("/WEB-INF/INS/DCAolAdd.jsp", request, getPortletConfig().getContext()), request, response);
    }

    /**
     * Implements the save action for the portlet's edit mode.
     * The action is executed as part of the submit URI before
     * doView gets control. The parameters that have been set by
     * the user in the edit form are retrieved from the request
     * and written to the portlet database through PortletData.
     * @param anEvent(org.apache.jetspeed.portlet.event.ActionEvent)
     * Event that it currently processed
     * @exception org.apache.jetspeed.portlet.PortletException
     * Exception thrown by this method
     */
    public void actionPerformed(ActionEvent anEvent) throws PortletException
    {
        // trace information
        PortletLog log = getPortletLog();
        if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): entering actionPerformed()...");

        DefaultPortletAction action = (DefaultPortletAction)anEvent.getAction();
        PortletRequest request = anEvent.getRequest();
        PortletSession session = request.getPortletSession();

        Map paramMap = request.getParameterMap();
        Set keySet = paramMap.keySet();
        Iterator itr = keySet.iterator();

        if (getPortletLog().isDebugEnabled())
        {
            StringBuffer sb = new StringBuffer();
            while (itr.hasNext())
            {
                Object key = itr.next();
                Object value = paramMap.get(key);
                sb.append("\n" + key + " = " + value);
            }

            getPortletLog().debug("action parameters =" + sb);
        }

        // get the parameters

        String dcName = request.getParameter("dcName");
        String dcUserId = request.getParameter("userid");
        String delayStartTime = request.getParameter("fromTime");
        String delayEndTime = request.getParameter("toTime");
        String selectedDelayTime = request.getParameter("selectedDelayTime");
        String cancel = request.getParameter("cancel.x");
        String delete = request.getParameter("delete.x");
        String addDelay = request.getParameter("addDelay.x");
        String deleteDelay = request.getParameter("deleteDelay.x");
        String modeParameter = null;

        TimeRange[] delayTimes = new TimeRange[6];
        for (int i = 0; i < delayTimes.length; i++)
        {
            String timeRangeString = request.getParameter("delayTime" + String.valueOf(i+1));
            if (timeRangeString != null)
            {
                delayTimes[i] = new TimeRange(timeRangeString);
                if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): read delay time " + delayTimes[i]);
            }
        }

        if (cancel != null)
        {
            // cancel has been selected, so don't do anything
            if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): cancelling");
            return;
        }
        else
        {
            String actionName = request.getParameter("action");
            if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): action is " + actionName);

            AolDeliveryChannelBean dcBean = null;
            if (action.getName().equalsIgnoreCase("add"))
            {
                // add mode
                dcBean = new AolDeliveryChannelBean();
                modeParameter = ADD_MODE_PARAMETER;
            }
            else
            {
                // modify mode
                DeliveryChannelBean tempBean = getDeliveryChannelFromSessionList(request, dcName);
                dcBean = new AolDeliveryChannelBean(tempBean);
                modeParameter = MODIFY_MODE_PARAMETER;
            }

            // set the properties that we have
            if (dcName != null)
            {
                dcName = dcName.trim();
                dcBean.setName(dcName);
            }

            if (dcUserId != null)
            {
                dcUserId = dcUserId.trim();
                dcBean.setUserId(dcUserId);
            }

            dcBean.setDelayTimeRanges(null);
            for (int i = 0; i < delayTimes.length; i++)
            {
                if (delayTimes[i] != null)
                {
                    try
                    {
                        dcBean.addDelayTimeRange(delayTimes[i]);
                        if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): added delay time " + delayTimes[i]);
                    }
                    catch (OverlappingTimeRangeException otre)
                    {
                        if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): unexpected overlapping exception caught: " + otre);
                    }
                    catch (TooManyDelayTimesException tmdte)
                    {
                        if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): unexpected too many delay times exception caught: " + tmdte);
                    }

                }
            }

            if (("addDelay.x".equals(actionName)) || (addDelay != null))
            {
                // we are adding a delay time
                if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): adding a new delay time");
                TimeRange delayTime = new TimeRange(delayStartTime + " - " + delayEndTime);
                if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): time = " + delayTime);

                if (!delayTime.isValid())
                {
                    // delay time is not valid, put the error on the request
                    request.setAttribute("errorId", "dcBaseErr.invalid_delay");
                }
                else
                {
                    // new delay time is ok, so add it to the dc
                    try
                    {
                        dcBean.addDelayTimeRange(delayTime);
                        if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): added delay time " + delayTime);
                    }
                    catch (OverlappingTimeRangeException otre)
                    {
                        // delay time we are attempting to add is overlapping existing delay times, and therefor is invalid
                        if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): overlapping exception caught: " + otre);
                        request.setAttribute("errorId", "dcBaseErr.invalid_delay_overlap");
                    }
                    catch (TooManyDelayTimesException tmdte)
                    {
                        // delay time we are attempting to add exceeds the maximum number of delay times
                        if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): too many delay times: " + tmdte);
                        request.setAttribute("errorId", "dcBaseErr.too_many_delay_times");
                    }
                }

                // put the in progress bean on the request
                request.setAttribute("dcBean", dcBean);

                // we need to stay in add/modify mode, so set the right attribute on the request
                request.setAttribute(MODE_KEY, modeParameter);
            }
            else if (("deleteDelay.x".equals(actionName)) || (deleteDelay != null))
            {
                // we are deleting a delay time
                if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): deleting a delay time");
                if (selectedDelayTime != null)
                {
                    int indexToRemove = Integer.parseInt(selectedDelayTime);

                    if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): removing index " + indexToRemove);

                    TimeRange[] oldDelayTimes = dcBean.getDelayTimeRanges();
                    TimeRange[] newDelayTimes = null;

                    if ((oldDelayTimes != null) && (oldDelayTimes.length > 1))
                    {
                        newDelayTimes = new TimeRange[oldDelayTimes.length - 1];

                        int j = 0;
                        for (int i = 0; i < oldDelayTimes.length; i++)
                        {
                            if (i != indexToRemove)
                            {
                                if (log.isDebugEnabled()) log.debug("AolDeliveryChannelController(actionPerformed): kept index " + i);
                                newDelayTimes[j] = oldDelayTimes[i];
                                j++;
                            }
                        }
                    }

                    dcBean.setDelayTimeRanges(newDelayTimes);
                }

                // put the in progress bean on the request
                request.setAttribute("dcBean", dcBean);

                // we need to stay in add/modify mode, so set the right attribute on the request
                request.setAttribute(MODE_KEY, modeParameter);
            }
            else if (("delete.x".equals(actionName)) || (delete != null))
            {
                // we are deleting this delivery channel
                if (dcBean != null)
                {
                    clearDeliveryChannelsFromSession(request);
                    String userDN = request.getUser().getID();
                    DeliveryChannelManager dcManager = DeliveryChannelManagerFactory.createDeliveryChannelManager(userDN, log);
                    try
                    {
                        dcManager.removeDeliveryChannel(dcBean);
                        // Remove rules associated with the delivery channel.
                        removeRulesAssociatedWithDeliveryChannel(dcBean, request);
                        if (getPortletLog().isDebugEnabled()) getPortletLog().debug("actionPerformed: removed default rules for dc, name=" + dcBean.getName());
                    }
                    catch (RemoveFailureException rfe)
                    {
                        if (log.isErrorEnabled()) log.error("AolDeliveryChannelController(actionPerformed): exception removing DC", rfe);
                        // error deleting delivery channel
                        request.setAttribute("errorId", "dcBaseErr.error_deleting_dc");
                        // put the in progress bean on the request
                        request.setAttribute("dcBean", dcBean);
                        // we need to stay in add/modify mode, so set the right attribute on the request
                        request.setAttribute(MODE_KEY, modeParameter);
                    }
                    dcManager.destroy();
                }
                else
                {
                    // error deleting delivery channel
                    request.setAttribute("errorId", "dcBaseErr.error_deleting_dc");
                    // put the in progress bean on the request
                    request.setAttribute("dcBean", dcBean);

                    // we need to stay in add/modify mode, so set the right attribute on the request
                    request.setAttribute(MODE_KEY, modeParameter);
                }
            }
            else
            {
                // we are completing the add or modify
                if (action.getName().equalsIgnoreCase("add"))
                {
                    // add mode
                    // check for errors before adding
                    if ((dcName == null) || (dcName.trim().equals("")))
                    {
                        // name is required
                        request.setAttribute("errorId", "dcBaseErr.dc_name_required");

                        // put the in progress bean on the request
                        request.setAttribute("dcBean", dcBean);

                        // we need to stay in add/modify mode, so set the right attribute on the request
                        request.setAttribute(MODE_KEY, modeParameter);
                    }
                    else if ((dcUserId == null) || (dcUserId.trim().equals("")))
                    {
                        // user id is required
                        request.setAttribute("errorId", "dcAolErr.Aol_id_required");
                        // put the in progress bean on the request
                        request.setAttribute("dcBean", dcBean);

                        // we need to stay in add/modify mode, so set the right attribute on the request
                        request.setAttribute(MODE_KEY, modeParameter);
                    }
                    else
                    {
                        // everything is ok, so add the delivery channel
                        try
                        {
                            clearDeliveryChannelsFromSession(request);

                            // we need to get the Aol server from the gateway
                            // adapter and set it in the delivery channel for some reason
                            String AolServer = getAolServerFromGatewayAdapter(log);
                            if (AolServer != null)
                            {
                                dcBean.setAolServer(AolServer);
                                String userDN = request.getUser().getID();
                                DeliveryChannelManager dcManager = DeliveryChannelManagerFactory.createDeliveryChannelManager(userDN, log);
                                dcManager.addDeliveryChannel(dcBean);
                                dcManager.destroy();
                                if (getPortletLog().isDebugEnabled()) getPortletLog().debug("actionPerformed: added dc, name=" + dcName);
                                // Add default rules associated with the delivery channels.
                                addDefaultRules(dcBean, request);
                                if (getPortletLog().isDebugEnabled()) getPortletLog().debug("actionPerformed: added default rules for dc, name=" + dcName);
                            }
                            else
                            {
                                // unable to retrieve the Aol server id, so either the gateway adapter isn't set up right
                                // or we just can't get to INS, either way, just throw an AddFailureException
                                throw new AddFailureException("Unable to retrieve Aol server information from Gateway Adapter config");
                            }
                        }
                        catch (NameAlreadyUsedException naue)
                        {
                            // name already exists
                            request.setAttribute("errorId", "dcBaseErr.dc_name_already_exists");
                            // put the in progress bean on the request
                            request.setAttribute("dcBean", dcBean);
                            // we need to stay in add/modify mode, so set the right attribute on the request
                            request.setAttribute(MODE_KEY, modeParameter);
                        }
                        catch (InvalidNameException ine)
                        {
                            // invalid dc name
                            request.setAttribute("errorId", "dcBaseErr.invalid_dc_name");
                            // put the in progress bean on the request
                            request.setAttribute("dcBean", dcBean);
                            // we need to stay in add/modify mode, so set the right attribute on the request
                            request.setAttribute(MODE_KEY, modeParameter);
                        }
                        catch (AddFailureException afe)
                        {
                            if (log.isErrorEnabled()) log.error("AolDeliveryChannelController(actionPerformed): exception adding DC", afe);
                            // general add failure
                            request.setAttribute("errorId", "dcBaseErr.error_saving_dc");
                            // put the in progress bean on the request
                            request.setAttribute("dcBean", dcBean);
                            // we need to stay in add/modify mode, so set the right attribute on the request
                            request.setAttribute(MODE_KEY, modeParameter);
                        }
                    }

                }
                else
                {
                    // modify mode
                    if ((dcUserId == null) || (dcUserId.trim().equals("")))
                    {
                        // user id is required
                        request.setAttribute("errorId", "dcAolErr.Aol_id_required");
                        // put the in progress bean on the request
                        request.setAttribute("dcBean", dcBean);

                        // we need to stay in add/modify mode, so set the right attribute on the request
                        request.setAttribute(MODE_KEY, modeParameter);
                    }
                    else
                    {
                        clearDeliveryChannelsFromSession(request);
                        String userDN = request.getUser().getID();
                        DeliveryChannelManager dcManager = DeliveryChannelManagerFactory.createDeliveryChannelManager(userDN, log);
                        try
                        {
                            dcManager.modifyDeliveryChannel(dcBean);
                        }
                        catch (AddFailureException afe)
                        {
                            if (log.isErrorEnabled()) log.error("AolDeliveryChannelController(actionPerformed): exception modifying DC", afe);
                            // general add failure
                            request.setAttribute("errorId", "dcBaseErr.error_saving_dc");
                            // put the in progress bean on the request
                            request.setAttribute("dcBean", dcBean);
                            // we need to stay in add/modify mode, so set the right attribute on the request
                            request.setAttribute(MODE_KEY, modeParameter);
                        }
                        if (getPortletLog().isDebugEnabled()) getPortletLog().debug("actionPerformed: modified dc, name=" + dcName);
                    }
                }
            }
        }
    }

    /**
     * Help functionality of the portlet.
     * The help JSP of the portlet is displayed.
     *
     * @param request(org.apache.jetspeed.portlet.PortletRequest)
     * Current portlet request
     * @param response(org.apache.jetspeed.portlet.PortletResponse)
     * Current portlet response
     * @exception org.apache.jetspeed.portlet.PortletException
     * Exception thrown by this method
     * @exception java.io.IOException
     * Exception thrown by this method
     */
    public void doHelp ( PortletRequest request,
                         PortletResponse response) throws PortletException, IOException
    {
        // trace information
        if (getPortletLog().isDebugEnabled())
        {
            getPortletLog().debug("AolDeliveryChannelController(doHelp): " +
                                  "entering doHelp()...");
        }

        // include JSP for extended search
        getPortletConfig().getContext().include("/WEB-INF/INS/AolDeliveryChannelHelp.jsp", request, response);
    }

    public String getProtocolType()
    {
        return AolDeliveryChannelBean.PROTOCOL_TYPE;
    }

    public String getProtocol()
    {
        return AolDeliveryChannelBean.PROTOCOL;
    }

    private String getAolServerFromGatewayAdapter(PortletLog log)
    {
        String retVal = null;
        ConfigSTBean adminSTBean = new ConfigSTBean(Locale.getDefault(), log, GatewayAdminConstants.ST_KEY);

        if (adminSTBean.load())
        {
            retVal = adminSTBean.getUndAolServer();
        }
        return retVal;
    }
}


