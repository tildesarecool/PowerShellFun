# Sept 14 2018
# only took me since July to make it hour 3
# here's hoping it's more informative than the first two hours

# I think I already skimmed this chapter. It's about the help system
# there is a useful command to update the help system kind of like
# a package manager from...every operating system except windows at this point

# the command to update the help system is: Update-Help
# I tried running it in the vscode ps console but it gave me an error
# doesn't look like a "run as admin" error, something else
# I'm going to try running it
Update-Help
# In a seperate PS console window set to run as admin:
# appears to be working
# I think I just shouldn't bother trying to use the VSCode PS console
# either that or run vscode as admin. couldn't be any worse. although i would have thought
# at least an MS product would be able to run safely without local admin privelege, or atleast an IDE anyay

# After a minute or so of apparently updating the help system I got this is error. 
#Not sure wha it means:

#Update-Help : Failed to update Help for the module(s) 'WindowsUpdateProvider' with UI culture(s) {en-US} : Unable to
#retrieve the HelpInfo XML file for UI culture en-US. Make sure the HelpInfoUri property in the module manifest is
#valid or check your network connection and then try the command again.
#At line:1 char:1
#+ Update-Help  
#+ ~~~~~~~~~~~
#    + CategoryInfo          : ResourceUnavailable: (:) [Update-Help], Exception
#    + FullyQualifiedErrorId : UnableToRetrieveHelpInfoXml,Microsoft.PowerShell.Commands.UpdateHelpCommand

# looks like i can save the download help files to local location and then point 
# Update-Help
# to that save location using -Source -- although my v5 on win 10 only has 
# -SourcePath
# as a choice
# I both updated help on my win 7 machine - also runing ps v5 - where it was successful
# and downloaded the help system to my network drive
# then pointed Update-Help at those local files...but it didn't work. Same error as above.
# i'm just going to roll with it though

# there's an alias for "Help" called "Man"
# help system seems to work how i might expect, for instance
Help *Event*
# would return results with the word event, like EventLog 
# so Help Get-EventLog
# return so help information on get event logs from local and remote pc both

#  

# I was trying to retrieve event logs from different PCs on the network but couldn't seem to get it to work
# not sure if i'm doing something wrong or maybe PS has to be "turned on" on those devices

# maybe i'll try one more time
Get-EventLog System -ComputerName (redacted) -Newest 10

# got error:
# Get-EventLog : The network path was not found.
# At line:1 char:1
# + Get-EventLog System -computer SURGBVVJ6Y1 -Newest 10
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : NotSpecified: (:) [Get-EventLog], IOException
#     + FullyQualifiedErrorId : System.IO.IOException,Microsoft.PowerShell.Commands.GetEventLogCommand
# this is porobably due to access level of network
# same error when i target localhost so i don't know
# this works
Get-EventLog System -Newest 10
# so clearly it's the network part of it
# these event log examples also mention directly getting a list of PCs to apply a command to via a text file
# which i think will come in handy for some other projects i'm thinking about
# for instance:
Get-EventLog Application -ComputerName(Get-Content names.txt)
# the intellisense filled that in. maybe that is what was wrong with the first one
Get-EventLog System -ComputerName localhost -Newest 10
# nope same error

# I'll try as many of the Lab exercises as possible
# first one i just run this. that's it. run it.
Update-Help
# 2) a cmdlet to make output in html
# I tried 
help *html*
# and got back
# The ConvertTo-Html cmdlet converts .NET Framework objects into HTML that can be displayed in a Web browser. You
# can use this cmdlet to display the output of a command in a Web page.
# so apparently this is the cmdlet that does literally this
# this
 Get-Help ConvertTo-Html -Examples
# has a lot of useful looking information. wow. a LOT of really good examples
# 3) cmdlets to redirect cmdlets output into a file or printer
# i found:
# The 
Out-File 
# cmdlet sends output to a file. You can use this cmdlet instead of the redirection operator (>) when
# you need to use its parameters.
# there's also 
Out-Printer
#     The Out-Printer cmdlet sends output to the default printer or to an alternate printer, if one is specified.
# those were pretty easy to find actually
# 4) how many cmdlets are available for working with processes?
# when i did this search
help *-process # note it's singular process...
# i got five results. not sure if that's right but that's what i got back:
# Debug-Process
# Get-Process                       
# Start-Process                     
# Stop-Process                      
# Wait-Process
# 5) what process might be used to /write/ to the event log?
help *eventlog*
# lead to 
Write-EventLog
# which has the right description to do this
# 6) all about aliases: create/modify/export/import aliases
# i used my easy goto
help *alias*
# and got back a bunch of alias-related commands:
Export-Alias # Exports information about currently defined aliases to a file.
Get-Alias
Import-Alias # imports from a file
New-Alias
Set-Alias # creates or changes an alias
# Alias - whatever a "provider" is 
# about_Aliases (help file)
# these seem pretty self-explanatory
# 
# 7) a way to keep a "transcript" of everything typed in shell and save that to a file
Start-Transcript # creates a record....
Stop-Transcript # stops transcript...
# 
# 8) what would retreive only the last 100 security event log entries?
Get-EventLog Security -Newest 100 # this will do it. I went over this on my own above
# 
# 9) way to retreive list of services installed on remote computer?
help *service* # this actually didn't retreive what i thought i wanted
# but since get-eventlog is a thing i tried 
help get-ser # and it filled in the rest of service
Get-Service # works
# according to 
help Get-Service
# The Get-Service cmdlet gets objects that represent the services on a local computer or on a remote computer,
# including running and stopped services.
# looks like it's the same format as Get-EvenLog, although i assume on this network it will work about as well as that command
# e.g. not at all
# 10) way to retreive list of processes installed on remote computer?
# as expected
Get-Process # works same as the other Get-* so far have worked
# 
# 11) looking the help file for
Out-File
# what is the default character width and is there a way to change the character width?
# Out-File is basically an alternative to using the redirect '>' with a bunch more optons
# added on
Get-Help Out-File -examples # this gives me a lot of information
# I'm actually not sure from this what the default character width is but it looks like 
# -Width 50
# would limit it to 50 and that 50 is cutting off part of the output so i would say some value
# more than 50 characters
# 
# 12) same premise as 11 but a question on avoiding over-writing an existing file
# apparently -NoClobber is made to do exactly this
# 
# 13) how would you list all aliases defined in PS?
Get-Alias # I think this about covers this actually
# 
# 14) using abbreviated parameter names and aliases what is shortest command line you could type
# to retreive list of running processes from computer named "Server1"?
# 
gps # this is get process
gps -Cn Server1 # i think this would work but i have no way to test it
# 
# 15) How many cmdlets are available that can deal with generic objects?
# I tried
help *object* # and it looks like either 9 or 11 depending if the two "about_" entries as "help files" count or not
# 
# 16) what help topic could explain more about arrays?
Get-Help arrays # good place to start
about_Arrays # seems to have a very extensive description of all things arrays
# 
#looking at answers...
# well i didn't use the noun/verb specification or get the details like the answers did 
# but at least i learned a lot
# 
# 
# 
# 
# 
# 
# 