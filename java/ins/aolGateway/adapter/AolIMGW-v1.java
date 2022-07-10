import java.lang.*;
import java.util.*;           
import java.net.*;
import java.io.*;

import com.ibm.pvc.we.ins.und.server.adaptors.*;
import com.ibm.pvc.we.ins.und.server.adaptors.transcoder.*;
import com.ibm.pvc.we.ins.und.server.dispatcher.*;
import com.ibm.pvc.we.ins.GeneralConstants.*;

public class AolIMGW implements DynamicGateway//, com.ibm.logging.IRecordType
{
   //private final static String insIBMCopyright=GeneralConstants.insIBMCopyright;
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
   // Screen name of current user
   protected String id;
   // The ID number for a SIGNON packet(FLAP)
   public static final int SIGNON = 1;
   // The ID number for a DATA packet (flap)
   public static final int DATA = 2;

   private Factory AOLFactory;

   private DeviceAddress deviceAddr;
   private Msg msg;

   private Properties gwconfig;


   public AolIMGW()
   {
       username = "REDACTED";//args[0];
       id = "REDACTED";
       password = "REDACTED";//args[1];
       recipient = "REDACTED";//args[2];
       message = "REDACTED";//args[3];

       System.out.println("***** AolIMGW - username=" + username);
       System.out.println("***** AolIMGW - password=" + password);
       System.out.println("***** AolIMGW - recipient=" + recipient );
       System.out.println("***** AolIMGW - message=" + message);

   }

   /** Method Description:
    * format message will format the message by either invoke default transcoder or apply user style sheet
    */
   public void formatMessage(DeviceAddress addr, Msg notificationMsg) {
      //Delete all formatting - not needed since we are doing no transcoding
      //we need to keep this method to keep Java happy since we are implementing
      //an interface

      //um, we should never get here, but .....
      System.out.println("***** AolIMGW - got into AOLIMGW formatMessage method");

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
      AOLFactory = f;
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

      System.out.println("***** AolIMGW - Entering AolIMGW.sendMessage method");
      System.out.println("***** AolIMGW - DeviceType: " + addr.getDeviceType() + " ,protocol: " + addr.getProtocol() );
      System.out.println("***** AolIMGW - fromUserid: " + msg.fromUserid );
      System.out.println("***** AolIMGW - toUserid: " + msg.toUserid );
      System.out.println("***** AolIMGW - Subject: " + msg.subject );
      System.out.println("***** AolIMGW - Message: " + msg.extractML() );
      message = msg.extractML();
      
      try {
         if (login(username,password)) {
             System.out.println("***** AolIMGW - Logged in");
             java.lang.Thread.sleep(5000);
             send(recipient,message);
             java.lang.Thread.sleep(2000);
             logout();
         }
       }
       catch ( Exception e ) {
           System.out.println("***** AolIMGW - exception caught");
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
       sendFlapSignon();
       String command = "toc_signon " +
                        authHost + " " +
                        authPort + " " +
                        id + " " +
                        roastPassword(password) + " " +       
                        language + " \"" +
                        version + "\"";

       System.out.println("***** AolIMGW - LoginCommand: " + command );

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
   protected void sendFlapSignon()
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

   // Send a IM
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

