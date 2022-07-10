package com.ibm.pvc.we.ins.portlets;
import java.util.*;
import java.io.Serializable;

/**
 * Bean representing an INS Delivery Channel
 */
public class AolDeliveryChannelBean extends DeliveryChannelBean implements Serializable
{
    public static final String PROTOCOL_TYPE = "im";
    public static final String PROTOCOL = "Aol";

    /**
     * default constructor
     */
    public AOLDeliveryChannelBean()
    {
        this(null, null, null);
    }

    /**
     * constructs a delivery channel bean with the passed in attributes set.
     * Any of the parameters may be <tt>null</tt>
     *
     * @param name  name of the delivery channel (all delivery channels for a
     *              user must have unique names)
     * @param delayTimes  array of time ranges for which this delivery channel is not available
     * @param properties  a map of any additional delivery channel specific properties
     */
    public AolDeliveryChannelBean(String name, TimeRange[] delayTimes, Map properties)
    {
        super(name,delayTimes,properties);
        this.putProperty("ibm-deviceidtype", "4");
        this.putProperty("ibm-deviceidtypeName", "SMS");
        this.putProperty("ibm-deviceidtype", "1");
        this.putProperty("ibm-deviceidtypename", "MSISDN");
        this.putProperty("ibm-appprotocolversion", "v15");
        this.setProtocolType(PROTOCOL_TYPE);
        this.setProtocol(PROTOCOL);
    }

    /**
     *  construct a Aol Delivery Channel from a DeliveryChannelBean.
     *
     *  @throws ClassCastException if the DeliveryChannelBean does not have to
     *                            proper settings to be a AolDeliveryChannel
     */
    public AolDeliveryChannelBean(DeliveryChannelBean dcBean)
    {
        this(dcBean.getName(), dcBean.getDelayTimeRanges(), dcBean.getProperties());
        if ((!dcBean.getProtocolType().equalsIgnoreCase(PROTOCOL_TYPE)) || (!dcBean.getProtocol().equalsIgnoreCase(PROTOCOL)))
        {
            throw new ClassCastException("DeliveryChannelBean is not a AolDeliveryChannelBean");
        }
    }

    /**
     * set the user ID for this delivery channel.
     */
    public void setUserId(String userId)
    {
        this.putProperty("ibm-appdeviceaddress",userId);
    }
    /**
     * get the user ID for this delivery channel.
     */
    public String getUserId()
    {
        return(String)this.getProperty("ibm-appdeviceaddress");
    }

    /**
     * set the Aol server for this delivery channel.
     */
    public void setAolServer(String serverName)
    {
        this.putProperty("ibm-undserver", serverName);
    }

    /**
     * get the Aol server for this delivery channel.
     */
    public String getAolServer()
    {
        return(String)this.getProperty("ibm-undserver");
    }

}
