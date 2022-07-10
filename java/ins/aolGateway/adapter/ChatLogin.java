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


public class ChatLogin extends javax.swing.JFrame {

   /**
    * The ChatBuddies object that this login screen belongs to.
    */
   public ChatBuddies owner;

   /**
    * The constructor.
    */
   public ChatLogin()
   {
     //{{INIT_CONTROLS
     setTitle("Mikes AIM(tm)");
     getContentPane().setLayout(null);
     setSize(400,134);
     setVisible(false);
     progress.setText("Please wait while you are logged in.");
     getContentPane().add(progress);
     progress.setBounds(12,84,300,24);
     JLabel2.setText("Password:");
     getContentPane().add(JLabel2);
     JLabel2.setBounds(12,48,72,24);
     getContentPane().add(password);
     password.setBounds(96,48,168,24);
     getContentPane().add(userID);
     userID.setBounds(96,12,168,24);
     login.setText("Login");
     login.setActionCommand("Login");
     getContentPane().add(login);
     login.setBounds(300,48,72,24);
     JLabel3.setText("User ID:");
     getContentPane().add(JLabel3);
     JLabel3.setBounds(12,12,60,24);
     JLabel1.setVerticalTextPosition(javax.swing.SwingConstants.TOP);
     JLabel1.setVerticalAlignment(javax.swing.SwingConstants.TOP);
     JLabel1.setText("This program is neither authorized nor endorsed by AOL(tm).");
     getContentPane().add(JLabel1);
     JLabel1.setBounds(12,108,384,24);
     //}}

     //{{INIT_MENUS
     //}}

     //{{REGISTER_LISTENERS
     SymAction lSymAction = new SymAction();
     login.addActionListener(lSymAction);
     SymWindow aSymWindow = new SymWindow();
     this.addWindowListener(aSymWindow);
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

   /**
    * Added by Visual Cafe
    */
   // Used by addNotify
   boolean frameSizeAdjusted = false;

   //{{DECLARE_CONTROLS

   /**
    * Indicates that the user is being logged in.
    */
   javax.swing.JLabel progress = new javax.swing.JLabel();
   javax.swing.JLabel JLabel2 = new javax.swing.JLabel();

   /**
    * The user's password.
    */
   javax.swing.JPasswordField password = new javax.swing.JPasswordField();

   /**
    * The user's screen name
    */
   javax.swing.JTextField userID = new javax.swing.JTextField();

   /**
    * The login button
    */
   javax.swing.JButton login = new javax.swing.JButton();
   javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
   javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
   //}}

   //{{DECLARE_MENUS
   //}}


   class SymAction implements java.awt.event.ActionListener {
     public void actionPerformed(java.awt.event.ActionEvent event)
     {
       Object object = event.getSource();
       if ( object == login )
         login_actionPerformed(event);
     }
   }

   /**
    * Called when the login button is clicked.
    *
    * @param event The event
    */
   void login_actionPerformed(java.awt.event.ActionEvent event)
   {
     progress.setVisible(true);
     owner.requestLogin();
   }



   class SymWindow extends java.awt.event.WindowAdapter {
     public void windowClosed(java.awt.event.WindowEvent event)
     {
       Object object = event.getSource();
       if ( object == ChatLogin.this )
         ChatLogin_windowClosed(event);
     }

     public void windowActivated(java.awt.event.WindowEvent event)
     {
       Object object = event.getSource();
       if ( object == ChatLogin.this )
         ChatLogin_windowActivated(event);
     }
   }

   /**
    * Called when this window is activated. Used to hide the "please
    * wait while you are logged in message".
    *
    * @param event The event
    */
   void ChatLogin_windowActivated(java.awt.event.WindowEvent event)
   {
     progress.setVisible(false);
   }

   /**
    * Called when the login window is closed. This terminates
    * the program.
    *
    * @param event The event
    */
   void ChatLogin_windowClosed(java.awt.event.WindowEvent event)
   {
     System.exit(0);
   }
}