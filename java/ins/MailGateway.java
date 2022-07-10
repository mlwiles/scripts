import java.lang.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

import com.ibm.pvc.we.ins.und.server.adaptors.*;
import com.ibm.pvc.we.ins.und.server.adaptors.transcoder.*;
import com.ibm.pvc.we.ins.und.server.dispatcher.*;
import com.ibm.pvc.we.ins.GeneralConstants;

public class MailGateway implements DynamicGateway, com.ibm.logging.IRecordType
{
   private String emailAddress;
   private int port;
   private String emailServer, transportProtocol;

   private Factory mailFactory;

   private DeviceAddress deviceAddr;
   private Msg msg;

   private Properties gwconfig;

   public MailGateway()
   {

   }

   /** Method Description:
    * format message will format the message by either invoke default transcoder or apply user style sheet
    */
   public void formatMessage(DeviceAddress addr, Msg notificationMsg) {
      //Delete all formatting - not needed since we are doing no transcoding
      //we need to keep this method to keep Java happy since we are implementing
      //an interface

      //um, we should never get here, but .....
      System.out.println("got into MailGateway formatMessage method");

   }

   /** Method Description:
    * Get emailserver host and port information from configuration
    */

   public void setProperties(Properties gwProperty)
   {
      //Keep this method since it is required for interface....
   }

   /** Method Description:
    * Get emailserver host and port information from configuration
    */

   public void setFactory(Factory f)
   {
      //Keep this method since it is required for interface....
      mailFactory = f;
   }


   /**
    * Formate message and send
    *
    * @param addr   email address
    * @param msg    Msg object encapsulating message
    * @return success code
    */

   public int sendMessage(DeviceAddress addr, Msg msg)
   {

      System.out.println("Entering MailGateway.sendMessage method");
      System.out.println("DeviceType: " + addr.getDeviceType() +
                         " ,protocol: " + addr.getProtocol() );
//    System.out.println("fromUserid: " + msg.fromUserid );
//    System.out.println("toUserid: " + msg.toUserid );
//    System.out.println("Subject: " + msg.subject );
//    System.out.println("Message: " + msg.extractML() );

      return 0;
   }
}
