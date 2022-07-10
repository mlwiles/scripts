import java.lang.*;
import java.util.*;           
import java.net.*;
import java.io.*;

import com.ibm.pvc.we.ins.und.server.adaptors.*;
import com.ibm.pvc.we.ins.und.server.adaptors.transcoder.*;
import com.ibm.pvc.we.ins.und.server.dispatcher.*;
import com.ibm.pvc.we.ins.GeneralConstants.*;

public class AolIMGW implements DynamicGateway
{
   // The username used to login as
   public String username;
   // The password for the username
   public String password;
   // The contents of the message
   public String message;
   // The username that is going to receive the message
   public String recipient;
   // The host address of the TOC server 
   public String tocHost = "toc.oscar.aol.com";
   // The port used to connect to the TOC server 
   public int tocPort = 9898;
   // The OSCAR authentication server
   public String authHost = "login.oscar.aol.com";
   // The OSCAR authentication server's port
   public int authPort = 5190;
   // What language to use
   public String language = "english";
   // The version of the client
   public String version = "IBM INS Gateway";
   // The string used to "roast" passwords.
   public String roastString = "Tic/Toc";
   // The sequence number used for FLAP packets.
   protected short sequence;
   // The connection to the TOC server.
   protected Socket connection;
   // An InputStream to the connection
   protected InputStream is;
   // An OutputStream to the connection
   protected OutputStream os;
   // The ID number for a SIGNON packet(FLAP)
   public static final int SIGNON = 1;
   // The ID number for a DATA packet (flap)
   public static final int DATA = 2;

   private Factory AOLFactory;
   private DeviceAddress deviceAddr;
   private Msg msg;

   private Properties gwconfig;
   private boolean loaded = false;
   private boolean toLog = false;
   // dynamic properties from the GW adapter properties file
   private String aolLOG = null;
   private String aolUID = null;
   private String aolPWD = null;
  
   private final static String KEY_AOL_LOG = "aolLOG";
   private final static String KEY_AOL_UID = "aolUID";
   private final static String KEY_AOL_PWD = "aolPWD";

   public AolIMGW()
   {
   }

   public void formatMessage(DeviceAddress addr, Msg notificationMsg) {
      //Delete all formatting - not needed since we are doing no transcoding
      //we need to keep this method to keep Java happy since we are implementing
      //an interface

      //um, we should never get here, but .....
      if (toLog) System.out.println("AolIMGW::formatMessage");

   }

   public void setProperties(Properties props)
   {
      if (!loaded) {
          
          aolLOG = props.getProperty(KEY_AOL_LOG);
          aolUID = props.getProperty(KEY_AOL_UID);
          aolPWD = props.getProperty(KEY_AOL_PWD);
                   
          toLog = aolLOG != null && aolLOG.toLowerCase().equals("true");

          if (toLog) System.out.println("AolIMGW::setProperties:AOL Log: " + aolLOG);
          if (toLog) System.out.println("AolIMGW::setProperties:AOL UID: " + aolUID);
          if (toLog) System.out.println("AolIMGW::setProperties:AOL PWD: " + aolPWD);

          loaded = true;
      }
   }

   public void setFactory(Factory f)
   {
      //Keep this method since it is required for interface....
      AOLFactory = f;
   }

   public int sendMessage(DeviceAddress addr, Msg msg)
   {

      if (toLog) System.out.println("AolIMGW::sendMessage");
      if (toLog) System.out.println("AolIMGW::sendMessage:Address: " + addr.getAddress() );
      if (toLog) System.out.println("AolIMGW::sendMessage:DeviceType: " + addr.getDeviceType() + " ,protocol: " + addr.getProtocol() );
      if (toLog) System.out.println("AolIMGW::sendMessage:fromUserid: " + msg.fromUserid );
      if (toLog) System.out.println("AolIMGW::sendMessage:toUserid: " + msg.toUserid );
      if (toLog) System.out.println("AolIMGW::sendMessage:Subject: " + msg.subject );
      if (toLog) System.out.println("AolIMGW::sendMessage:Message: " + msg.extractML() );
      message = msg.extractML();
      recipient = addr.getAddress();
      
      try {
         if (login(aolUID,aolPWD)) {
             if (toLog) System.out.println("AolIMGW::sendMessage - Logged in");
             java.lang.Thread.sleep(1000);
             send(recipient,message);
             java.lang.Thread.sleep(500);
             logout();
         }
       }
       catch ( Exception e ) {
           if (toLog) System.out.println("AolIMGW::sendMessage exception caught");
           e.printStackTrace();
       }

      return 0;
   }

   // Log in to TOC
   public boolean login(String id,String password)
   throws IOException
   {
       connection = new Socket(tocHost,tocPort);
       is = connection.getInputStream();
       os = connection.getOutputStream();
       sendRaw("FLAPON\r\n\r\n");
       getFlap();
       sendFlapSignon(id);
       String command = "toc_signon " +
                        authHost + " " +
                        authPort + " " +
                        id + " " +
                        roastPassword(password) + " " +       
                        language + " \"" +
                        version + "\"";

       if (toLog) System.out.println("AolIMGW::login - LoginCommand: " + command );

       sendFlap(DATA,command);
       String str = getFlap();

       if ( str.toUpperCase().startsWith("ERROR:") ) {
           handleError(str);
           return false;
       }

       sendFlap(DATA,"toc_add_buddy " + id);
       sendFlap(DATA,"toc_init_done");
       sendFlap(DATA,"toc_set_caps 09461343-4C7F-11D1-8222-444553540000 09461348-4C7F-11D1-8222-444553540000");
       sendFlap(DATA,"toc_add_permit ");
       sendFlap(DATA,"toc_add_deny ");
       return true;
   }

   // Logout of toc and close the socket
   public void logout()
   {
       try {
           connection.close();
           is.close();
           os.close();
       } catch ( IOException e ) {

       }
   }

    // Passwords are roasted when sent to the host.  This is done so they
    // aren't sent in "clear text" over the wire, although they are still
    // trivial to decode.  Roasting is performed by first xoring each byte
    // in the password with the equivalent modulo byte in the roasting
    // string.  The result is then converted to ascii hex, and prepended
    // with "0x".  So for example the password "password" roasts to
    // "0x2408105c23001130"
   protected String roastPassword(String str)
   {
       byte xor[] = roastString.getBytes();
       int xorIndex = 0;
       String rtn = "0x";

       for ( int i=0;i<str.length();i++ ) {
           String hex = Integer.toHexString(xor[xorIndex]^(int)str.charAt(i));
           if ( hex.length()==1 )
               hex = "0"+hex;
           rtn+=hex;
           xorIndex++;
           if ( xorIndex==xor.length )
               xorIndex=0;
       }
       return rtn;
   }

   // Send a string over the socket as raw bytes
   protected void sendRaw(String str)
   throws IOException
   {
       os.write(str.getBytes());
   }

   // Write a multi-byte word
   protected void writeWord(short word)
   throws IOException
   {
       os.write((byte) ((word >> 8) & 0xff) );
       os.write( (byte) (word & 0xff) );

   }

   // Send a FLAP signon packet
   protected void sendFlapSignon(String id)
   throws IOException
   {
       int length = 8+id.length();
       sequence++;
       os.write((byte)'*');
       os.write((byte)SIGNON);
       writeWord(sequence);
       writeWord((short)length);

       os.write(0);
       os.write(0);
        os.write(0);
       os.write(1);

       os.write(0);
       os.write(1);

       writeWord((short)id.length());
       os.write(id.getBytes());
       os.flush();

   }

   // Send a FLAP packet
   protected void sendFlap(int type,String str)
   throws IOException
   {
       int length = str.length()+1;
       sequence++;
       os.write((byte)'*');
       os.write((byte)type);
       writeWord(sequence);
       writeWord((short)length);
       os.write(str.getBytes());
       os.write(0);
       os.flush();
   }

   // Get a FLAP packet
   protected String getFlap()
   throws IOException
   {
       if ( is.read()!='*' )
           return null;
       is.read();
       is.read();
       is.read();
       int length = (is.read()*0x100)+is.read();
       byte b[] = new byte[length];
       is.read(b);
       return new String(b);
   }

   // Parse an error packet
   protected void handleError(String str)
   {
       StringTokenizer tok = new StringTokenizer(str,":");
       tok.nextElement();
       String e = (String)tok.nextElement();
       String v = "";
       if ( tok.hasMoreTokens() )
           v = (String)tok.nextElement();
   }

   // Send an IM
   public void send(String to,String msg)
   {
       try {
           sendFlap(DATA,"toc_send_im " + normalize(to) + " \"" + 
                         encode(msg) + "\"");
       } catch ( java.io.IOException e ) {
       }
   }
   // Called to normalize a screen name. This removes all spaces
   // and converts the name to lower case.
    protected String normalize(String name)
   {
       String rtn="";
       for ( int i=0;i<name.length();i++ ) {
           if ( name.charAt(i)==' ' )
               continue;
           rtn+=Character.toLowerCase(name.charAt(i));
       }

       return rtn;

   }

   // Called to encode a message. 
   protected String encode(String str)
   {
       String rtn="";
       for ( int i=0;i<str.length();i++ ) {
           switch ( str.charAt(i) ) {
           case '\r':
               rtn+="<br>";
               break;
           case '{':
           case '}':
           case '\\':
           case '"':
               rtn+="\\";

           default:
               rtn+=str.charAt(i);
           }
       }
       return rtn;
   }
}

