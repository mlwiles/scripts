import java.io.*;
import java.util.*;
import JavaTOC;  

public class MyAIM implements Runnable,Chatable
{
   protected JavaTOC toc = new JavaTOC(this);

   //command line values that are need to login and send a message
   static String username;
   static String password;
   static String message;
   static String recipient;
  
   public MyAIM(){
     //constructor used to call the tread method - run()
     try {
       Thread t = new Thread(this);
       System.out.println("starting tread");
       t.start(); 
     } catch ( Exception e ) {
       System.out.println(e);
     }
   }
       
    public static void main(String[] args){
          username = args[0];
          password = args[1];
          recipient = args[2];
          message = args[3];
    
          new MyAIM();
      }
       
       public void run() {
          try {
            System.out.println("running...");
    
            //attempt to login as the passed in user
            if ( toc.login(username,password) ) {
              System.out.println("Logged in " + username);
            } else {
              System.out.println("nope");
              return;
            }
    
            //sleep to allow authentication and then send the message
            java.lang.Thread.sleep(5000);
            System.out.println("sending message");
            toc.send(recipient,message);
    
            //sleep to allow sending of message and then logout
            java.lang.Thread.sleep(2000);
            System.out.println("logging out");
            toc.logout();
            
          } catch ( Exception e ) {
              System.out.println(e);
          }
       }
       
       public void unknown(String str)
       {
       }
       
       public void im(String from,String message)
       {
       }
    
       public void error(String str,String var)
       {
       }
}
