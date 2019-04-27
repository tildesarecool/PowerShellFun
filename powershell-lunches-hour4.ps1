# chapter 4
# 20 Sept 2018
# chapter 4 at least looks like it's only about 12 pages
# i'm sure they will be quite jam packed though
# 
# terms  
# 
# cmdlet: native ps commandline utility. written in .net framework language such as c#. 
# function: similar to cmdlet, but rather than being written in a .net language fucntions are written
# in powershell's own scripting language
# workflow: special kind of function that ties into powershell's workflow execution system
# application: any kind of external executable such as ping or ipconfig
# command: generic term for above terms
# 
# alias: note on ps alias versus bash/unix alias is that ps alias is only for the command 
# not for any extra paramters sent to it
# 
# taking shortcuts with parameters:
# 
# truncating: parameter needs just enough to distinguish it, like -compu for computername to distinguish
# from other parameters like -composite e.g. -compo
# 
# parameter name aliases:
# tricky to get them to list. example given for evenlog for computername:
#(Get-Command Get-EventLog | select -ExpandProperty parameters).computername.aliases
# the above only outputs "Cn". apparently this shortcut isn't in the help or anything, 
# just a thing you have to find. or something
# 
# 
# using positional parameters:
# when there is one parameter always in the same place in order, such as "-Path" with the 
# Get-ChildItem 
# command the actual "-Path" can be skipped and simply a path can be inserted
# e.g.
Get-ChildItem C:\Users
# vs
Get-ChildItem -Path C:\Users
# if the order is messed up in any way the command could fail so it has to absolutely right
# ###########################################################################################
# side note, I got this command to work. first time it actually did something not an error
# with the -computername flag
Get-EventLog -LogName system -ComputerName . -Newest 10
# this one also doesn't error but it also doesn't provide any output
Get-EventLog -LogName system -ComputerName . -Newest 10 -UserName [redacted]
# this one does though. guess i just had to provide the (domain) part. i am logged in as this login. 
# no idea why it's necessary
Get-EventLog -LogName system -ComputerName . -Newest 10 -UserName [redacted]\[redacted]
# ###########################################################################################
# 
# The 
Show-Command
# has something of a GUI (which it's noted doesn't work on gui-less windows servers)
# to help walk through the commands 
# it's actually pretty nice (pg. 45)
# 
# There's a mention of using the string --% for things that should be passed on directly to cmd.exe parser
# but the examples cited are 
# 
# i got some more information with 
 Get-Help about_parsing
# apparently the --% is the "stop parsing" and it is aimed more at parameters of command lines utilities, 
# especially the kind not built in to cmd
# STOP PARSING:  --%
# 
#
# ###########################################################################################
# The stop-parsing symbol (--%), introduced in Windows PowerShell 3.0,
# directs Windows PowerShell to refrain from interpreting input as
# Windows PowerShell commands or expressions.
# 
# When calling an executable program in Windows PowerShell, place the
# stop-parsing symbol before the program arguments. This technique is
# much easier than using escape characters to prevent misinterpretation.
#
# When it encounters a stop-parsing symbol, Windows PowerShell treats
# the remaining characters in the line as a literal. The only
# interpretation it performs is to substitute values for environment
# variables that use standard Windows notation, such as %USERPROFILE%.
#
# The stop-parsing symbol is effective only until the next newline or
# pipeline character. You cannot use a continuation character (`) to
# extend its effect or use a command delimiter (;) to terminate its effect.
# 
# Beginning in Windows PowerShell 3.0, you can use the stop-parsing
# symbol.
# 
#     icacls X:\VMS --% /grant Dom\HVAdmin:(CI)(OI)F
# 
# Windows PowerShell sends the following command string to the
# Icacls  program:
#     X:\VMS /grant Dom\HVAdmin:(CI)(OI)F
#
# 
# (below is april 2019)
# 
# the book mentions "net use" as a "works good enough no need to replace example" for cmd commands
# then proceeds to list the PS replacement for net use
# or more specifically something of a generic command that could be used as a replacement
# in the form of the 
# New-PSDrive  command with -Persist parameter
# 
# it also mentioned Test-Connection as an alternative to ping but as the book says
# it doesn't seem like a long of advantage over regular ping
# 
# ################################### 25 april 2019 ########################################################
# I've since realized for something PS can't handle, like the SC command, 
# i can simply use 
# cmd /c sc
# thus PS will flip to cmd, run "sc" and exit out back to PS
# the --% does sound like it would be useful for escaping environment variables though
# 
# ################################### 25 april 2019 ######################################################### 
#

# ################################### 26 april 2019 ######################################################### 
# it seems PS has some aliases to make it somewhat backwards compatible with CMD, like dir
# but dir /s doesn't work because passing the "/s" to the underlying PS command is invalid
# but using "dir -rec" would work
# of course "cmd /c dir /s" also works but I'm assuming that can't be piped or do all the fancy stuff
# that's the whole purpose of PS
# 
# lab for chapter 4: "using the help system"
# 
# 1. displaying a list of running processes
# first I ran "Get-Help process"
# in that list is "Get-Process" the description of which looks promising
Get-Process
# does indeed apparently list all the processes
# 
# 2. Displaying the 100 most recent entires from the application event log, not using Get-WinEvent
# 
# tried "Get-Help eventlog"
# and noticed "Get-EventLog"
# 
# So i tried "Get-Help Get-EventLog"
# 
# that gave me some hints, but i needed more so I tried "Get-Help Get-EventLog -Examples"
# 
# which lead to "Get-Eventlog -LogName system -Newest 1000"
# 
# so I tried
Get-Eventlog -LogName Application -Newest 100
# 
# 3. Display all "cmdlet" type commands
# first I tried "Get-Help Get-Command -Examples" since it worked so well previously
# and sure enough there's
Get-Command -Type Cmdlet | Sort-Object -Property Noun | Format-Table -GroupBy Noun
# which the description says lists all cmdlets. is that easy? copy/paste? where's the tricky part?
# also, that is a lot of cmdlets
# 
# 4. Display a list of all aliases
# I used "Get-Help Get-Command -Examples" again 
# and also realized the command from 3 could be modified for aliases
# thus we have this command here
# 
Get-Command -Type Alias | Sort-Object -Property Noun | Format-Table -GroupBy Noun
# 
# 
# 5. make an alias so I can run notepad via command 'np'
# I used 
Get-Help alias
# 
# and it automatically included all the examples
# including literally one that will createp an alias "np" for notepad.exe
# i suppose an exercise is an exercise though, right?
# so here's command. it's just a copy/paste
# 
new-item -path alias:np -value c:\windows\notepad.exe
# 
# indeed, np now executes notepad
# I guess an alias is sort of link a symbolic link?
# i think i would still prefer good old mklink myself
# but i may need to study this alias thing a bit more
# 
# 6. display a list of services that start the the letter M
# note sure if this is even right or not but
Get-Process M*
# does show me a list of process and they all start the M so i'm counting it
#
# 7. display a list of all windows firewall rules, help or get-command may be ncessary to find which command
# 
# I started with 
Get-Help firewall
# in the list is "Get-NetFirewallRule" which looks promissing
# actually i guess "Show-NetFirewallRule" also looks like it could be it
# 
# I looked at 
Get-Help Show-NetFirewallRule -examples
# which only had the one example with this description:
# "This example displays all of the firewall rules currently in the active policy, which is the collection of all of the policy stores that apply to the computer."
# I don't know. It's probably right.
# the command being:
Show-NetFirewallRule –PolicyStore ActiveStore
# wow. that is a LOT of firewall rules. 
# 
# I also looked at
Get-Help Get-NetFirewallRule -examples
# which has 
Get-NetFirewallRule -PolicyStore ActiveStore
# which looks remarkably similar to the show one. I mean the command itself. they both have "policystore" and "activestore". Seem kind of similar.
# the output also looks similar
# I peaked at the answers and...i have no idea. the question wasn't specific enough. maybe the commands i used didn't exist when the book was written 
# 
# 8. Display a list of only inbound firewall rules. Same command okay to use
# 
# I've already read a lot of help files
# I made it to
Get-NetFirewallProfile -Name Public | Get-NetFirewallRule
# and i think i'm close. shows everything though
# -Direction Inbound
# this might work
# 
# I think i got it:
Get-NetFirewallRule -Direction Inbound
# this does fit the question. The exercise isn't that specific about it. the output only includes inbound rules
# so i'm counting it as complete
# 
# 
# 
# ################################### 26 april 2019 ######################################################### 
# 
# 
# 
# ################################### 27 april 2019 ######################################################### 
# 
# 
# ################################### 27 april 2019 ######################################################### 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
