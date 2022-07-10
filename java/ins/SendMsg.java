import com.ibm.pvc.we.ins.*;
import java.util.*;
import java.io.*;

public
class SendMsg
{
   static public void main( String args[] )
   {
      if (args.length < 4)
      {
         System.out.println("usage: SendMsg <UNDhost> <UNDPort> <sender> <receiver> optional: <any|all> <priority> <devicelist>");
         System.exit(0);
      }

      String undHost = args[0];
      String undPort = args[1];
      String sender = args[2];
      String receiver = args[3];
      String multi = "any";
      String priority = "Normal";

      DeliveryOptionsExtended senderPrefs = new DeliveryOptionsExtended();

      if (args.length > 4)
      {
         multi = args[4];
         if (args.length > 6)
         {
            priority = args[5];
            for (int i=6; i<args.length; i++)
            {
               senderPrefs.addDevice(args[i]);
            }
         }
         else
         {
            senderPrefs.addDevice("mail");
         }
      }
      else
      {
         senderPrefs.addDevice("mail");
      }

      senderPrefs.setPriority(priority);
      senderPrefs.setMultiDevices(multi);

      String notificationML = "<message><to>" + receiver + "</to><from>" + sender + "</from><subject>hello</subject><text>world</text></message>";

      System.out.println("the msg sent: " + notificationML);

      try
      {
         NotificationService ns = new NotificationService(undHost, new Integer(undPort).intValue());
         System.out.println( "created a notification service object" );
         int rc = ns.sendMessage( notificationML, senderPrefs );
         System.out.println("ReturnCode is " + rc );
      }
      catch (Exception e)
      {
         System.out.println("Caught exception: "+e.getMessage() );
         e.printStackTrace(System.out);
      }
   }
}
