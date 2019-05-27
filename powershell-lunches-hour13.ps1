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
# ################################## 13.3 enter-pssession and exit-pssession - one-to-one remoting
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
# ################################## 13.4 invoke-command for one-to-many remoting e.g. 1:1 remoting
# 
# sending a coming to multiple remote computers at the same time
# 
# each pc independantly execute command and send results back
# 
# all done via invoke-command 
# 
# the sample has a comma separated list of server names, i'm just going to use my one PC instead
# and also I looked up an actual event ID to make sure I returned some results
# 
Invoke-Command -ComputerName GalacticaGamer7 -Command { Get-EventLog Security -Newest 10 | where { $_.EventID -eq 4672 } }
# 
# only one PC so I hardly saw the signifcance of this "one to many" invoke-command. It is interesting it runs and exits though. 
# that could be useful
# 
# By default PS can talk to 32 comptuers at once and after that starts to queue up the rest
# this limit can be raised with the -throttleLimit parameter of invoke-command
# 
# the -command parameter is actuall an alias/nickname for the -scriptblock parameter
# -command is not in help while -scriptblock is
# 
# -scriptblock can also specify an actual script file in place of a command for the remote computer to run
# theoretically a bunch of remote machines could used to run a portion of work over time
# although that seems like a weird example of the use of something like that
# 
# invoke-command can use a comma separated list of host names instead of one, like this
# and this does work
Invoke-Command -ComputerName GalacticaGamer7,ThinkCentre1 -Command { Get-EventLog Security -Newest 10 | where { $_.EventID -eq 4672 } }
# 
# but invoke-command can also get a list of host names from a one-per-line text file thanks to paranthesis
# 
Invoke-Command -Command { dir } -ComputerName ( Get-Content .\computers.txt )
# this also works perfectly well - the PC has the 3 extra host names and also "localhost" which also happens to have worked
# 
# this, it is suggested, could be used to run commands against categories of PCs like web servers or file servers.
# 
# this method however would not work with the AD-specific command, Get-ADComputer: 
# Get-ADComputer produces actual computer objects while the -computerName as well as get-content are based entirely around
# text strings
# 
# this can be worked around with fileter and expand:
Invoke-Command -Command { dir  } -ComputerName ( Get-ADComputer -filter * -searchBase "ou=Sales,dc=company,dc=pri" | Select-Object -expand name  )
# this i have no way to test but I think I can tell what's happening: the -expand paraemter is extracting the Name property of whatever comes in via the computer object
# so inside the parantheses will result in a list of computer names not computer objects which can then be presented as a string to -computerName
# 
# extra note: -filter specifies that all computers should be included in the commands output
# and
# -searchbase tells the command to start looking for computers in the specified location e.g. the sales OU on the primary domain
# 
# 
# ################################## 13.5 differences between remote and local commands
# 
# for this section this command example will be referenced:
Invoke-Command -ComputerName GalacticaGamer7,ThinkCentre1,ToughPeg -Command { Get-EventLog Security -Newest 10 | Where-Object { $_.EventID -eq 4672 } }
# 
# ################ 13.5.1 invoke-command vs -computerName
# 
# theoretically this should run just as easily as the above
Get-EventLog Security -Newest 10 -ComputerName GalacticaGamer7,ThinkCentre1,ToughPeg | Where-Object { $_.EventID -eq 4672 } 
# however it does not work for me. I actually tried it only with "localhost" and wihtout the other names or where object part
# and got the same can't find network path error in call cases so i'll just read this and not participate
# 
# 
# differences between get-eventlog with -computername parameter and the invoke-command version of the get-eventlog
# the get-eventlog with -computername version. actually any cmdlet with the -computername parameter
# 
# - computers are contacted sequentially instead of in parallel - this may take longer for the command to run
# - output doesn't include a pscomputername proeprty making it harder to tell which results are from which pc
# - conneciton is not made via winrm, instead using an underlying .net framework protocol, this may affect firewall connections etc
# - this first queries the 200 records from each computer /then/ filters through to find the eventid 1212 so a lot of records not needed end up coming over
# - the event log objecst are fully functional
# 
# with the invoke-commmand version, the first example above:
# 
# - computers cotnacted in paralell
# - output has a "PSComputerName" property for more clarity in output
# - connection uses WinRM for single port used and other details are easier
# - when the 200 records are queried it's done on that local computer as well as the filtering. the only thing trasmitted over the network are the results
# - each remote host serializes the ouput into xml and transmits where the local PC deserializes it back into into somethign resembling objects.
#           --- these aren't real event objects and this may limit what can be done with those objects
# 
# 
# ################ 13.5.2 local vs remote processing
# 
# Taking this same example from above:
Invoke-Command -ComputerName GalacticaGamer7,ThinkCentre1,ToughPeg -Command { Get-EventLog Security -Newest 10 | Where-Object { $_.EventID -eq 4672 } }
# 
# and looking at a barely noticable alternative version:
Invoke-Command -ComputerName GalacticaGamer7,ThinkCentre1,ToughPeg -Command { Get-EventLog Security -Newest 10 } | Where-Object { $_.EventID -eq 4672 } 
# 
# 
# the main difference is the brace: 
# in the first line it starts at get-eventlog and ends at the end of the command and another set are around eventid
# in the second line it starts at get-eventlog and ends right before the pipe then the second set of braces are around eventid
# 
# second version: get-eventlog is invoked remotely. results generated from get-eventid are serialized and sent to the local pc
#    - where they are deserialized into objects then piped to where and filtered
#    - this is less effecient because a lot of unnecessary data is being transmited across the netework and our computer has to filter the results from 3 comptuers rather
#    - than the comptuers filtering their down results
# 
# Another command with two versions:
# spoiler: this first one deosn't work
# 
Invoke-Command -ComputerName ThinkCentre1 -Command { Get-Process -Name notepad } | Stop-Process
# 
# second version:
# (yes, this one works)
Invoke-Command -ComputerName ThinkCentre1 -Command { Get-Process -Name notepad  | Stop-Process }
# 
# the reason the first version doesn't work:
# the Get-Process -Name notepad  is sent to the remote computer
# that remote computer retreives the specified process, serializes it into xml and sends it back across netowrk to the local pc
# the local PC then deserializes that xml back into an object and pipes it into "stop-process"
# the deserialized xml doesn't have enough info for the local computer to realize the command is supposed to aimed at the remote pc
# so it instead tries to stop a local process called notepad, not the intention
# 
# the emphasis here is that doing as much processing on the remote PC is always preferred 
# 
# whenever invoke-command is used always look at the commands after it: if those are for formating/exporting data it's good
# if those are action cmdlets starting with start-, stop-, set-, change- etc pause and think of what the goal is
# always keeping in mind the command should run on the remote pc, not the local one
# 
# ################ 13.5.2 deserialized objects in more detail
# 
# objects that come back to the local pc from a remote pc are not "fully functional"
# - in most cases they lack methods as they are no longer "attached" to "live" software
# - these are "read-only" objects - can't be told to stop/pause/resume/etc
# 
# for instance running this removes all but one method from the output:
Invoke-Command -ScriptBlock { Get-Service } -ComputerName ThinkCentre1 | Get-Member
# (actually two methods but they are "universal" -- gettype and tostring)
# 
# 
# 
# 
# ################################## 13.6: pointless random statement about a thing in chapter 20
# 
# as covered in chapter 20, re-usable, persistent connections can be created
# 
# 
# ################################## 13.7: remote options
# 
# enter-pssession and invoke-command both have a -sessionoption parameter
# this accepts a <PSSessionOption> object
# 
# session option can be used to specify such things as:
#  - open/cancellation/idle time-outs
#  - turning on/off normal data stream compression or encryption
#  - some proxy related stuff
#  - skipping remote machine SSL cert/name/other security features
# 
# example of opening a session and skipping the machine name check:
Enter-PSSession -ComputerName ThinkCentre1 -SessionOption ( New-PSSessionOption -SkipCNCheck )
# 
# 
# ################################## 13.8: some further tips
# 
# - when using invoke-command, the remote computer is asked to launch PS, run the command and then close PS
#    the next invoke command on the same computer starts from scratch, the command from the first thing run is no longer in effect
#    for a whole series of commands put them all in the same invokation [ i don't think this was covered...comma seperated? semi-colons? ]
# - GPOs will override anyting local
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
#  cmd /c C:\install\Node.js\node-v12.3.1-x64.msi /qr
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
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
