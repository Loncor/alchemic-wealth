---
layout: post
author: Stan
---
In October 2018 William Hardie from Oracle Corporation announced Oracle Database 18c XE. It is a free, community supported edition of their popular Database. These **Express Edition** databases are not released **too** often as with the list below.

Database Version|Year of Release
----------------------------- | ----- 
Oracle Database 10g XE|2005
Oracle Database 11g XE|2011 
Oracle Database 18c XE|2018 
|=====

If you are upgrading you will be jumping from Oracle XE 10/11g to Oracle XE 18c. In a company or organisation that task would be major undertaking because of extensive testing required notwithstanding all the development and installation involved. I have been involved in many Oracle Database upgrades over the years and Oracle Corporation has increasingly made it easier to upgrade from one release to the next.

I have been running my own Oracle Express installations for many years and recently decided to make the move from Oracle XE 11g to Oracle XE 18c. For reasons I will not bore you with I decided to do **least effort** upgrade rather than following **best practice**. Here are the steps for the Microsoft Windows version. Hopefully, you find installation as easy as I did:-

1. Go to the [Oracle Database Express Edition Downloads|https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html] page.
1. Accept the user license - if you agree to the conditions!
1. Take a note of the Sha256sum below the Windows x64 Download.
1. Click on the Download link.
1. After download of the ZIP file OracleXE184_Win64.zip right-click and choose **Extract All...** and choose the **new** folder suggested.
1. Open the folder created and double-click setup.exe.
1. Agree to the installation - if that is what you want!
1. The InstallShield Wizard will start and click **Next**.
1. Accept the user license - if you agree to the conditions!
1. If you are happy with installation directory click **Next** otherwise click **Change**.
1. You will be asked to enter a password of your choice for the SYS, SYSTEM and PDBADMIN accounts that will be created, click **Next**.
1. Take a note of the Destination folder and Oracle Home and Base and click the **Install** button.
1. A firewall alert should appear choose the settings you prefer. Note: this will be the Java runtime that belongs this installation.
1. Installation should take a few minutes. The **Oracle Database Successfully Installed** screen will show you connection information including;-
1.1. The Multitenant container database.
1.1. The Pluggable Database.
1.1. The Enterprise Manager (EM) Express URL

I had several schemas that I need to import. I have been using Oracle Data Pump technology to copy my Production Data to my Development Database. This is part of my development release routine:-

1. Make changes to development system (e.g. source code, table changes).
1. Test changes on development system.
1. Backup Production System.
1. Release development code and/or reference data to production system using release scripts.
1. Extract Production data using Oracle Data Pump.
1. Import Oracle Data Pump data into Development System
1. Run **special scripts** on Development System (this ensures Development database compliance). 

Here are the hurdles I needed to get past to   

