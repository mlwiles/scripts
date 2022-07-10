package com.ibm.pvc.we.ins.util;

import com.ibm.pvc.we.ins.dse.*;
import java.util.*;
import javax.naming.*;
import javax.naming.directory.*;

public class CreateAolDeliveryChannel
{
   public static void main(String[] args)
   {
      try
      {
         if (args.length < 4)
         {
            System.out.println( "usage: CreateAolDeliveryChannel <DSE_host:port>, <userid>," + 
                               " <Delivery_channel_name>, <device_address>" );
            System.exit(0);
         }

         String dseHostPort = args[0];
         String userID = args[1];
         String dcName = args[2];
         String deviceAddr = args[3];
         System.out.println( "Connecting to DSE using " + dseHostPort );
         DSEClient client = new DSEClient();
         client.init( dseHostPort );

         /* Add the Delivery Channel */
         System.out.println( "Adding Delivery Channel " + dcName + " for user " + userID );

         String qualifiedUserID = userID + "@ins.realm";
         NSDeviceProfile device = new NSDeviceProfile();

         device.addAVPair( "deviceID", dcName );
         device.addAVPair( "ibm-deviceIDType", "4" );
         device.addAVPair( "ibm-deviceType", "6" );
         device.addAVPair( "ibm-appProtocolVersion", "none" );
         device.addAVPair( "ibm-appDeviceAddress", deviceAddr );
         device.addAVPair( "ibm-appProtocolType", "wap" );
         device.addAVPair( "ibm-appProtocol", "none" );
         device.addAVPair( "ibm-undIpServicePort", "0" );
         device.addAVPair( "ibm-undserver", " " );

         if ( !client.setNSDeviceProfile( device, qualifiedUserID ) )
         {
            client.stop();
            System.out.println( "Error encountered adding Delivery Channel " + dcName + " for user " + userID );
            System.out.println( "See the DSE log for details." ); 
            return;
         }
         System.out.println( "Successfully added Delivery Channel " + dcName + " for user " + userID );

         client.stop();
         return;

      }
      catch ( DSEException e )
      {
         e.printStackTrace();
         return;
      }
   }
}
