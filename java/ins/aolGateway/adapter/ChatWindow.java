import java.awt.*;
import javax.swing.*;

/**
  * The JavaTOC framework is a set of classes used to allow
  * a Java program to communicate with AOL's TOC protocol.
  * The Chatable interface and JavaTOC classes can easily
  * be moved to any program needing TOC abilities.
  *
  *  Copyright 2002 by Jeff Heaton
  *
  *   This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
  *  as published by the Free Software Foundation; either version 2
  *  of the License, or (at your option) any later version.
  *
  *  This program is distributed in the hope that it will be useful,
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  *
  * @author Jeff Heaton(http://www.jeffheaton.com)
  * @version 1.0
  */


public class ChatWindow extends javax.swing.JFrame {

   /**
    * The ChatBuddies object that this object belongs to
    */
   public ChatBuddies owner;

   /**
    * Who is this conversation with.
    */
   public String with;

   /**
    * Holds the text of previous messages.
    */
   protected String listing = "";

   /**
    * The constructor.
    */
   public ChatWindow()
   {
     //{{INIT_CONTROLS
     getContentPane().setLayout(null);
     setSize(405,265);
     setVisible(false);
     send.setText("Send");
     send.setActionCommand("Send");
     getContentPane().add(send);
     send.setBounds(312,228,81,24);
     log.setContentType("text/html");
     log.setEditable(false);
     getContentPane().add(log);
     log.setBounds(12,12,384,204);
     getContentPane().add(text);
     text.setBounds(12,228,288,24);
     //}}

     //{{INIT_MENUS
     //}}

     //{{REGISTER_LISTENERS
     SymAction lSymAction = new SymAction();
     send.addActionListener(lSymAction);
     //}}
   }

   /**
    * Added by Visual Cafe
    */
   public void addNotify()
   {
     // Record the size of the window prior to calling parents addNotify.
     Dimension size = getSize();

     super.addNotify();

     if ( frameSizeAdjusted )
       return;
     frameSizeAdjusted = true;

     // Adjust size of frame according to the insets and menu bar
     Insets insets = getInsets();
     javax.swing.JMenuBar menuBar = getRootPane().getJMenuBar();
     int menuBarHeight = 0;
     if ( menuBar != null )
       menuBarHeight = menuBar.getPreferredSize().height;
     setSize(insets.left + insets.right + size.width, insets.top + 
insets.bottom + size.height + menuBarHeight);
   }

   // Used by addNotify
   boolean frameSizeAdjusted = false;

   //{{DECLARE_CONTROLS

   /**
    * The send button
    */
   javax.swing.JButton send = new javax.swing.JButton();

   /**
    * The scrolling list of messages.
    */
   javax.swing.JEditorPane log = new javax.swing.JEditorPane();

   /**
    * The text that the user is entering.
    */
   javax.swing.JTextField text = new javax.swing.JTextField();
   //}}

   //{{DECLARE_MENUS
   //}}

   /**
    * Called to add a message to the scrolling display. Usually
    * called from ChatBuddies as the IM's come in.
    *
    * @param from Who is the message from
    * @param message The message
    */
   public void addMessage(String from,String message)
   {
     int start = message.indexOf('>');
     if ( start!=-1 )
       start = message.indexOf('>',start+1);
     start++;

     int end = message.lastIndexOf('<');
     if ( end!=-1 )
       end = message.lastIndexOf('<',end-1);
     if ( end!=-1 )
       listing += from +":" + message.substring(start,end) + "<br>";
     else
       listing += from +":" + message + "<br>";
     this.log.setText(  "<html><body>" + listing + "</body></html>" );
   }



   class SymAction implements java.awt.event.ActionListener {
     public void actionPerformed(java.awt.event.ActionEvent event)
     {
       Object object = event.getSource();
       if ( object == send )
         send_actionPerformed(event);
     }
   }
   /**
    * Called when the Send button is clicked. This actually sends an
    * IM.
    *
    * @param event The event
    */

   void send_actionPerformed(java.awt.event.ActionEvent event)
   {
     String message = "<html><body>" + text.getText() + "</body></html>";
     owner.requestIM(with,message);
     this.addMessage("<b><font color=\"red\">"+owner.login.userID.getText()+"</font></b>",message);
     this.text.setText("");

   }
}