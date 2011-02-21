Cerb5 Plugins - net.pixelinstrument.weekly_report
=================================================
Copyright (C) 2011 Davide Cassenti
[http://davide.cassenti.it/](http://davide.cassenti.it/)  

What's this?
------------
The plugin allows to allow workers to send out (weekly) reports within the Cerberus interface. Those reports are automatically filled with many information (tickets worked on, customers notes, SLA etc.) and require the workers to fill in a form with the details of their (weekly) work.

The `weekly` word is just to explain how this is supposed to work: the plugin does not verify that a worker is sending the report on a weekly basis and, in fact, the report can be sent even twice in the same day.

Notes on the SLA
----------------
The SLA related calculations are performed by another plugin `net.pixelinstrument.sla`; if the plugin is missing or not installed, these information are simply not appearing in the page.

Installation
------------
* Change directory to **/cerb5/storage/plugins/**
* `git clone git://github.com/cerb5-plugins/net.pixelinstrument.weekly_report.git`
* In your helpdesk, enable the plugin from **Setup->Features & Plugins**.

Credits
-------
This plugin was developed by [Davide Cassenti](http://davide.cassenti.it/).

License
-------

GPLv3 
[http://www.gnu.org/licenses/gpl-3.0.txt](http://www.gnu.org/licenses/gpl-3.0.txt)  
