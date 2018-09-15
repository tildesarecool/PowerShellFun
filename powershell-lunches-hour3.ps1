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
# i'm just goin gto roll with it though

# there's an alias for "Help" called "Man"
# help system seems to work how i might expect, for instance
Help *Event*
# would return results with the word event, like EventLog 
# so Help Get-EventLog
# return so help information on get event logs from local and remote pc both

# SURGBVVJ6Y1 



