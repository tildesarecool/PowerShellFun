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
# alias: note on ps alias versus bash/unix alias is that ps alias is only for the command not for any extra paramters sent to it
# 
# taking shortcuts with parameters:
# 
# truncating: parameter needs just enough to distinguish it, like -compu for computername to distinguish
# from other parameters like -composite e.g. -compo
# 
# parameter name aliases:
# tricky to get them to list. example given for evenlog for computername:
#(Get-Command Get-EventLog | select -ExpandProperty parameters).computername.aliases
# the above only outputs "Cn". apparently this shortcut isn't in the help or anything, just a thing you have to find. or something
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
# this one does though. guess i just had to provide the marshmed part. i am logged in as this login. no idea why it's necessary
Get-EventLog -LogName system -ComputerName . -Newest 10 -UserName [redacted]\[redacted]
# ###########################################################################################
# 
# The 
Show-Command
# has something of a GUI (which it's noted doesn't work on gui-less windows servers)
# to help walk through the commands 
# it's actually pretty nice
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
# ###########################################################################################
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
