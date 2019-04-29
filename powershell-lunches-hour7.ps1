# ################################### 29 april 2019 ######################################################### 
# 
# chapter 7: by your...command?
# 
# 
# At least according to this book...powershell and it's extension framework has similiarities with
# the MS Managment console is that snip-ins can be added to a blank MMC console function-by-function
# 
# this can be used in PS for other products not included by default like AD, exchnage server etc
# 
# on a server 2008 r2 domain controller there could be a "active directory module for powershell" item
# under the properties for that item in the start menu will be this in the target box:
# %windir%\system32\windowspowershell\v1.0\powershell.exe -noexit -command import-module ActiveDirectory
# 
# as it implies, this open a powershell prompt and runs that import module command but this could 
# just as easily be run directly from a powershell window
# 
# extensions: finding/adding snap-ins
# 
# two kinds of extensions: moduels and snap-ins
# 
# ---> snap-ins: more properly called "PSSnapin". introduced in PS v1 and involving DLLs these are being depreciated
# /skip/
# 
#########################################################
# 
# extensions: finding/adding modules
# 
# limited PS v2/v3 (and later)
# 
# designed to be self-contained and easier to distribute
# 
# PS looks in a certain set of paths to find modules, as reported by the "PSModulePath" environment variable
# 
# can see path(s) with:
# type env:psmodulepath
# or
Get-Content Env:\PSModulePath
# mine seems to be:
# C:\Users\(profile)\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\Windows\system32\WindowsPowerShell\v1.0\Modules
# 
# so i guess....documents folder of profile, program files and system32
# 
# personal modules would be added to the profile/documents location
# and these paths can be modified via GPEdit or system properties/advanced/env variables. apparently not in PS itself (maybe setx?)
# 
# it's worded a little awkwardly, but I think what the books is saying is that the PS shell looks in those locations and auto-loads 
# modules it finds, after that loading them automatically so they never have to be manually loaded
# and the modules will work like native ones even responding to get-help
# 
# 
# as an example the command
Get-Module | Remove-Module
# will unload all the loaded modules.
# then running something like 
help *network*
# will make the PS shell discover the modules with network in their name
# 
# I tried this and i did see an update-help progress bar flash briefly then a long list of network-related cmdlets listed
# 
# tips:
Get-Module
# retrieves a list of modules available on a remote computer and import-module will load that modules from the remote PC (covered later)
# 
# to import a modules not in the auto-included paths you can use 
Import-Module
# and the full path to the modules 
# 
# modules can also bring in new PSDrive providers which can be identified with 
Get-PSProvider
# 
# 
######################################################### commond conflicts/remove extensions
# 
# if there was for some reason a name duplicate/conflict, like get-user, a name/command name has be specified
# you can always remove a modules with
Remove-Module # < module name >
# 
# 
######################################################### playing with a new module
# 
# goal: clear the dns name resolution cache on local pc
# 
# start with 
help *dns*
# to see what comes up
# well i already see
Clear-DnsClientCache
# so lets go with that
# 
# to find out what other options there with this dns module, first import
Import-Module -name DnsClient
# 
# then do a get command 
Get-Command -Module DnsClient
# 
# the import would have happend of course by just running Clear-DnsClientCache but we're experimenting here
# 
# lacking any required paramters, i can use the clear dns thing. or use verbose to make it tell me it ran
Clear-DnsClientCache -verbose
# 
# and that's all it says. that dns cache was cleared, congrats
# 
######################################################### preloading extensions when the shell starts
# 
# the first part of this is about auto loading snap-ins with a psc file which are depreciated so...skip
# 
# well it's a little confusing because page 85 only mentions snap-ins and page 86 says "snap-ins and modules"
# okay, whatever
# these steps are only necessary if you wanted to pre-load modules that aren't in the PSModulePath
# not sure what the point of that is. guess just an extra feature. or there will be a more advanced application
# much later in the book
# 
# ---> creating a "profile script"
# 
# -> 1. create a new folder called "windowspowershell" in the Documents folder
# -> 2. in this folder create a file named profile.ps1
# -> 3. in the text file and import-module commands one per line in the order you want them loaded
# -> 4. back in the PS Shell, enable "script execution" via command 
Set-ExecutionPolicy RemoteSigned
# -> 5. close/re-open shell which will auto-execute the profile.ps1 file
# 
# 
######################################################### modules from internet
# 
# to summarize, there's a MS-operated PS repository with matching modules, called "PowerShellGet" for v5 and later
# it acts like a package manager for PS modules
# i think chocolatey/nugget is more complete/popular anyway
# but whatever, insert ad here
# moving on...
# 
######################################################### chapter 7 lab
# 
# Only one thing, more of an exercise: run the "Network troubleshooting pack"
# press enter at the "instance ID" prompt and run the "web connectivity check"
# it lists a specific URL to try it against but i doubt it matters...
# 
# *************************
# 
# I started with 
help *troubleshooting*
# which does indeed list
Get-TroubleshootingPack
# so i could use help Get-TroubleshootingPack but instead i'll just run it straight and see what happens
# apparently it requires -path parameter
# and after some experimenting it only knows WHICH troubleshooting pack to get based on a directory name 
# in summary this finally didn't produce an error:
Get-TroubleshootingPack -Path C:\Windows\diagnostics\system\Networking
# 
# now that probably i have the networking troubleshooting pack, i'll run what i assume to be the other half,
Invoke-TroubleshootingPack
# 
# I had to use
get-help Invoke-TroubleshootingPack -examples
# to figure out how to use the invoke thing, but based on the exmples I did this one
# 
Get-TroubleshootingPack -Path C:\Windows\diagnostics\system\Networking | Invoke-TroubleshootingPack
# 
# and did the rest. aginst google.com because whatever. and it gave me back some -1s. which I just assume is good.
# 
# well the book approach was a little different than mine. but as long as it works
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
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
