# ################################### 27 april 2019 ######################################################### 
# 
# chapter 5: "whatever a provider is"
# 
# this chapter opens telling me a provider is an adapter, which doesn't really help
# then it says it "takes some kind of data storage and makes it look like a disk drive"
# 
# later it says "a provider is used to create a PSDrive" which is "a single provider to connect to data storage"
#
# I mean okay...there's the "subst" command from like 1987 and mounting storage devices in the file system
# which goes back to windows 2000 so i'm not even sure what that means
# not to mention DISM and mounting WIM images
# it doesn't say "mounted volumes" it says "disk drives" specifically
# but then i see the the out ouput of the command
Get-PSProvider
# which gives this output:
# Name                 Capabilities                                                              Drives
# ----                 ------------                                                              ------
# Registry             ShouldProcess, Transactions                                               {HKLM, HKCU}
# Alias                ShouldProcess                                                             {Alias}
# Environment          ShouldProcess                                                             {Env}
# FileSystem           Filter, ShouldProcess, Credentials                                        {C, P}
# Function             ShouldProcess                                                             {Function}
# Variable             ShouldProcess                                                             {Variable}
####################################
# 
# so perhaps it's "even more conceptual" in that you can access registry and things like a block of device? 
# 
# The parameters, in the "capabilities" column, are "parameters" which related directly to the different capabilities
# - shouldprocess - provider has support for -WhatIf and -Confirm which makes it possible to test a command before commiting to it
# - filter - supports -Filter parameter on the cmdlets that manipulate provider's content
# - Credentials - usesd as -credentail parameter, when connecting to data stores allows for alt credentials
# - transactions - allows provider to make a series of changes and then either roll back or commit to those changes
# 
# going back to above:
#  "a provider is used to create a PSDrive" which is "a single provider to connect to data storage"
# not even sure what that means
# 
# it goes on to say the PSProvider dapats the datastore and the psdrive makes it accessible.
# a set of cmdlets are then used to see and manipualte the data exposed by each psdrive
# cmdlets used with psdrive typically have the word "Item" some where in their noun
# per the command 
Get-Command -noun *item*
# I don't really feel like pasting the entirety of the output but here's a sampling:
# CommandType     Name                                               Version    Source
# -----------     ----                                               -------    ------
# Function        Get-DAEntryPointTableItem                          1.0.0.0    DirectAccessClientComponents
# Function        Get-TestDriveItem                                  3.4.0      Pester
# Function        New-DAEntryPointTableItem                          1.0.0.0    DirectAccessClientComponents
# Function        Remove-DAEntryPointTableItem                       1.0.0.0    DirectAccessClientComponents
# Function        Rename-DAEntryPointTableItem                       1.0.0.0    DirectAccessClientComponents
# Function        Reset-DAEntryPointTableItem                        1.0.0.0    DirectAccessClientComponents
# Function        Set-DAEntryPointTableItem                          1.0.0.0    DirectAccessClientComponents
# Cmdlet          Clear-Item                                         3.1.0.0    Microsoft.PowerShell.Management
####################################
# 
# starting with filesystem PSProvider...
# 
# starting with think of folders and files objects, 
# drives being top level objects, folders being containers and files being "endpoint objects"
# 
# PS uses the more generic term "item" for everything regardless
# this is to make it easier to point to non-fileystem things like the registry easier conceptually, thus the item noun thing
# 
# 
# these "items" have properties like write-time, readonly, etc
# some items have child items contained within
# 
# verbs: such as clear, copy, get, move, new remove, rename and set can apply to all items such as files and folders
# as well as to item properties like date the item was last written and whether  or not it's read only, creation date, length, etc
# item noun: refers to invidual objects like files/folders
# itemproperty noun: refers to attributes of an item like read-only creation time, length, etc
# childItem noun: refers to items like files/folders, contained within an item
# 
# some cmdlets or properties don't apply to some PSProviders
# forinstance environment variables won't have item properties and the registry provider doesn't work with filter
# 
#################################### 
# 
# set-location
# used to change the shell's current location to a different container-type item suchas a folder:
Set-Location -Path C:\Windows\
# it's cd. it's the same as cd. i assume other contexts will make knowing this form more obvious
# 
# similarly, PS has an equivalent for make directory/mdkdir
# this PS version will require "-type directory" to work though
# because mkdir is just an alias to the longer command:
New-Item -Type Directory testfolder
# again, i'm assuming this will come in use in other non-fileystem based contexts
# 
####################################
# 
# wildcards and literal paths
# 
# most of item cmdlets include a -path property which by default accepts wildcards
# 
# in the help for a command it will often mention under -path that wildcards are accepted
# * is all characters/one or more
# ? is one character in that spot
# 
# to get around the issue of other contexts like the registry have item names that can contain the ?, 
# the parameter -LiteralPath can be used in place of -Path, which does not interpret anythying as a wildcard
# it just takes everything it sees as it sees it
# 
####################################
# 
# working with non-filesystem providers
# 
# example: turning off the "aero peek" feature (does win 10 even have that?)
# 
# first set the location to the HKCU portion of the registry:
Set-Location -Path hkcu:
# that trailer : is important. like a drive letter. needs a colon.
# 
# then navigate to the software part of the registry with:
Set-Location -Path software
# although
# cd Software
# works just as well
# 
# can the use either "dir" or 
Get-ChildItem
# to see everything in that part of the registry
# and change over to "microsoft"
# then change to windows
# yes, apparently 10 does have this "enable aeropeek" entry
# 
# then use set-itemproperty to set the EnableAeroPeek value to 0 with:
# 
Set-ItemProperty -Path dwm -PSProperty EnableAeroPeek -Value 0
# 
# indeed, a "dir" shows that this value is now 0
# well the book didn't what that did or how to undo it but i just use the up arrow and set it back to a 1
# 
#################################### chapter 5 lab ####################################
# 
# 1. In the registry, location the advanced key and set its "dontpretty path property" to a 1
# in registry, changed context to 
# HKCU:\software\Microsoft\Windows\CurrentVersion\Explorer\
# and modified prior command to:
Set-ItemProperty -Path advanced -PSProperty DontPrettyPath -Value 1
# 
# which did indeed flip it from 0 to 1. not even sure what the setting is. it's fine, i'll leave it.
# 
# 
# 2. create a new directory called c:\labs
# I think this will do it:
New-Item -Type Directory c:\testfolder
# yep
# 
# 3. use new-item to create a zero-length files name test.txt inside c:\labs folder
# I tried this command and it did indeed work:
# 
New-Item -Type File C:\testfolder\test.txt
# 
# 4. is it possible to use set-item to change the contents of the c:\labs\test.txt to TESTING? dor is there an error? if an error, why?
# 
# feels like i missed a detail on this one. where did it imply set-item could insert content into a text file?
# well i tried this one anyway:
 Set-Item -value TESTING .\test.txt -confirm
# which obviously gave me an error because why would it not. it's not made to insert content into files. i don't think.
# 
# 5. using the Environment provider, display the value of the system environment variable %temp%
# first switched context to env:
Set-Location env:
# then used dir to see all the env variables listed
# and 
# dir te*
# actually shows the varaible and its value. that's probably not what the book had in mind 
# or maybe it is
# well not with "dir" but close enough
# 
# 6. with get-childitem, what are the differences between paramters -Filter, -Include, and -Exclude?
# filter: qualifies the path parameter, are applied when retreiving objects instead of after the objects are retrieved
# include: qualifies the path parameter, specifies as a string array item(s) that the cmdlet includes in the operation. wild cards are permitted
# takes a path element or pattern such as *.txt
# only effective when includes the recurse parameter or path leads to the conents of a directory (c:\windows\*)
# 
# exclude: qualifies the path parameter, specifies as a string array item(s) that the cmdlet includes in the operation. wild cards are permitted
# takes a path element or pattern such as *.txt
# 
# i think the differences are that include/exclude simply include or exclude things via a string array while filter deals more intelligently with actual objects
# 
# 
# --------------- answers
# 
# 5. this is the one about the environment variables. apparently these will work:
Get-Item Env:\TEMP
# dir Env:\TEMP
# 
# 6. i think ig to this one largely right although the book differentiates them by support the -Recurse parameter
# 
# ################################### 27 april 2019 ######################################################### 
# 
# 
# 
# 
