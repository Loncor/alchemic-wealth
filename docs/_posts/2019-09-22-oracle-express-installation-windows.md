---
layout: post
author: Stan Wilson
---
**Microsoft Windows installation**. Hopefully, you find installation as easy as I did:-

{% include important.html content="The **absolute minimum** thing you must do is **backup your Database** before proceeding." %}

1. Go to the [Oracle Database Express Edition Downloads](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) page.
1. Accept the user license - if you agree to the conditions!
1. Take a note of the Sha256sum below the Windows x64 Download.
1. Click on the Download link.
1. After download of the ZIP file OracleXE184_Win64.zip right-click and choose **Extract All...** and choose the **new** folder suggested.
1. Open the folder created and double-click setup.exe.
1. Agree to the installation - if that is what you want!
1. The InstallShield Wizard will start and click **Next**.
1. Accept the user license - if you agree to the conditions!
1. If you are happy with installation directory click **Next** otherwise click **Change**.
1. You will be asked to enter a password of your choice for the creation of SYS, SYSTEM and PDBADMIN user accounts. Do so and click **Next**.
1. Take a note of the Destination folder and Oracle Home and Base and click the **Install** button.
1. A firewall alert should appear choose the settings you prefer. Note: this will be the Java runtime that belongs this installation.
1. Installation should take a few minutes. The **Oracle Database Successfully Installed** screen will show you connection information including;-
   1. The Multitenant container database.
   1. The Pluggable Database.
   1. The Enterprise Manager (EM) Express URL
