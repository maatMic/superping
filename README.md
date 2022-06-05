# superping
Powershell tool for network ip scanning


This is a powershell module, to install it, I recommend putting the superping directory in C:\Program Files\WindowsPowerShell\Modules\
Make sure that it's execution is allowed by your Powershell configuration, then import it with:

import-Module superping

This module accepts two sets or arguments:
        -  a single ip address (in it's numerical form, ex: 192.168.1.1) to scan it's Mac Address and Vendor Name
        -  two ip addresses, to scan all ip's in between
        
        
As of now, the tool only works for /24 ranges, and won't scale from other octets.



Bug report:

        - current host's ip is ommited in the report
