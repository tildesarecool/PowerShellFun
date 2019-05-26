# ################################### 25 May 2019 ######################################################### 
# 
# chapter 13: PS Remoting
# 
# I wrote up a summary (probably accurate) on day 31 of the 100 days of code blog
# so I'll leave this here as a reference rather than trying to re-write
# long story short yes, PSRemoting works win 10 to win 7 and back again, at least of today 
# and win 10 1809
# 
# https://tildesare.cool/2019/05/25/100-days-of-code-day-31/
# 
# 
###################################
# 
# I think I'm goign to try somethign a little different for chapter 13
# I'm goign to see if I can just summarize each section in 2 or at most 3 sentences
# rather than trying for more detail as I've done before
# i'll have to see how it goes to see if I keep at it like this
# 
###################################
# 
# the shell-wide system for connecting to network machines and running PS commands is "remoting"
# this seems roughly equivelent to telnet or SSH but works a little differently
# and also over port 80 and http/https
# 
################################### 13.1
# PS Remoting uses the protocol WS-MAN (a service running by default on client win 10 and I guess added to win 7)
# the service is called WinRM
# at least as of server 2012/win 8 WinRM was off by defualt on clients and on by default on servers
# 
# the output objects sent over a PS Network session are "serialized" into XML
# and "deserialized" back into objects from XML (Object -> XML -> psduedo object)
# this serialization/deserialization is a form of format conversion
# 
# these objects upon return via deserialization are merely snapshots of the state of those objects
# at the time the command was run e.g. CPU or memory usage wouldn't be auto updated to reflect changes
# of their use
# 
# requirements of remoting: 
# 
# - both local and remote PC must be on ps v2 or later (xp can run v2)
# - this bullet point says getting remoting to work outside a domain but I didn't find it that trick so whatever...
# - WinRM won't by default permit connecting by using an IP or DNS alias (via 13.3)
# 
################################### 13.2 - winRM (default port tcp 5985)
# 
# WinRM isn't only for PS, it is and can be used for mlutiple adminstrative applications
# 
# WinRM is something of a dispatcher, deciding which application gets which traffic and 
# what traffic goes to which applicaiton (I guess they can't call it a "router" that would be confusing)
# 
# Applications must register as "endpoints" with WinRM before WinRM will listen for traffic tagged for that application
# 
# so both WinRM has to be enabled and PS has to be registered as an endpoint with WinRM
# 
# PS calls WinRM endpoints "session conigurations"
# different end points can point to different applications and multiple applications can point to one endpoint
# but with different permissions and functionality
# 
# for instance a PS Session for one user that only allows for two commands with specific limits on those two
# 
# A WinRM listener waits for incoming traffic on behalf of winrm for incoming requests - similar with web server
# 
# the command
Enable-PSRemoting
# performs steps for enabling the winrm service and configuring it then registering WinRM as an endpoint
# also making the appropriate rule in the windows firewall
# the network interface does have to be set to "home" or "private" (not public)
# 
# the default port for PS remote sessions can be changed if necessary but it then has to be specified
# 
# Remoting can be configured via GPO
# by default remoting will be limited to administrators
# 
# #################################
# 
# PS uses remoting in to ways: one-to-one and and one-to-many
# 
# ##################################
# 
# ################################## enter-pssession and exit-pssession - one-to-one remoting
# 
# one-to-one remoting: accessing shell prompt on single rmeote computer, and any commands will run directly
# on that computer - the results displaying in the shell window
# similarity could be drawn with RDP/remote desktop (is that really a good example?)
# 
# one-to-one connection establish with a remote PC:
Enter-PSSession -ComputerName GalacticaGamer7
# 
# and exit:
Exit-PSSession
#
# shell prompt changes:
# [GalacticaGamer7]: PS C:\Users\Keith\Documents>
# (the win 7 machine)
# 
# on domains, authenticaiton is passed via Kerberos so any command run on the remote PC will be via 
# the credentials used on the local PC
# 
# a couple of caveats:
# - a PS profile script - used to do things like like loading extensions/modules on PS startup for instance -
# won't auto run for the remote session
# - the remote PC's execution policy is still in affect which means the "RemoteSigned" policy on the remote
# PC will reject any scripts that try to run if it's set to "restricted" versus for an unsigned script
# 
# remoting chains: to be avoided (also claled "the second hop")
# example: remote to "Server-R2" and while remoted there remote still further into "server-dc4"
# the reason given is something like "hard to keep track of" and "imposes unnecessary overheard"
# both reasons seem fixable and kind of weak but i'll just go with it
# 
# In one-to-one remoting there is 
# no need to worry about the serialization/deserialization
# objects.
# it is as if commands are being typed directly at that PC keyboard
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
#################################### 29 april 2019 ######################################################### 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
