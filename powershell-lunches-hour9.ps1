# ################################### 29 april 2019 ######################################################### 
# 
# chapter 9: piped piper of piping 2: the pippening (pipeline parameter binding)
# 
# 
# ################################### How PS passes data down the pipeline
# 
# when commands are stringed together powershell has to figure out how to get the output of the
# first command to the input of the second command
# 
# in subsequent examples the first command will be 
# "Command A" - the command that produces something
# "Command b" - accepts the output of command A and moves on
# 
# as in:
# PS C:\ > commandA | commandB
# 
# Chapter will be using sample text file, called computers.txt:
# SERVER2
# WIN8
# CLIENT17
# DONJOES1D96
# 
# as example of a possible use:
Get-Content .\computers.txt | Get-Service # this actually wouldn't work 
# when get-content runs it places the computer names into the pipeline
# PS the has to decide how to get those to the get-service command
# PS commands can only accept input on a parameter
# PS has to figure out which parameter of get-service will accept out of the get-content
# 
# this process of PS figuring out which parameter is called ---------> pipeline parameter binding
# 
# PS has two methods for getting the get-content output onto a parameter of get-service:
# - ByValue
# - ByPropertyName
# 
# 
################################### the first mehtod: ByValue
# 
# PS looks at the type of object command A has produced and tries to see if any parameter of Command B
# can accept the output object type from the pipeline
# 
# to determine this arbitrarily:
# pipe command A to get-member to see what type of object command A is producing
# 
# then examine the help of command B to see whether any parameter accepts thaat type of
# data from the pipeline ByValue
# 
# for instance looking at the ouptut from "get-member" of get-content shows a "type: system.string"
# while the help of get-service has a name parameter that is of type string and accepts pipeline input by "ByValue"
# 
# looking at the help for get-service however, the -name parameter is actually for the service name, not the host name
# so the below command would have get-service trying to find SERVICE names based on the host names in computers.txt
# 
Get-Content .\computers.txt | Get-Service # this actually wouldn't work as intended
# 
# PS permits just the one parameter to accept a given type of object from the pipeline ByValue.
# Since the -Name parameter accepts STRING  from the pipeline ByValue no other parameter can do so
# so this prevents piping computer names from the text file to get-service
# 
# Looking at an example that works on the CLI
Get-Process -name note* | Stop-Process
# 
# Using the suggestions above, first pipe Command A e.g. get-process, to get-member
# 
# then look at the help for command B, e.g. stop-process
# 
# get-process produced objects of type System.Diagnostics.process
# stop-process can accept the process bojects from the pipeline ByValue via the -InputObject parameter
# 
# that -InputObject parameter says in help (this varies from what the book says so I copied what the actual help says)
# "Specifies the process objects to stop. Enter a variable that contains the objects, or type a command or expression that gets the objects."
# This means command A gets one or more process objects and command B stops/kills them
# 
# This emphasizes a valid point about PS as this is a great example of pipeline parameter binding in action
# - commands that share the same noun, -process in this case, can usually pipoe to each other by value
# 
# next example:
Get-Service -name s* | Stop-Process
# 
# looking at the get-member of get-service and the help for stop-process, 
# get-service produces objects of type ServiceController
# But there are not any parameters of stop-process that can accept a service controller object
#
# in which case PS will try the second method: ByPropertyName
# 
# 
# 
################################### the second mehtod: ByPropertyName
# 
# Like ByValue, this is still trying to attach the output of Command A to parameters of Command B
# but with ByPropertyName it's possible for multiple paraemters of command B to become involved
# 
# still looking at 
Get-Service -name s* | Stop-Process
# it turns out command A (get-service) has one property whose name corresponds to a parameter in command B (stop-process)
# That would be "name". As in there's a "name" in the "get-member" list and there's a -name parameter via stop-process
# 
# Literally ALL this means is that the shell is looking for preoprty names that match parameter names
# the gm has "name" and stop-process has a "-name"
# since they're spelled the same the shell tries to connect the two...
# 
# But the shell can't do so right away as it first needs see whether the -name parameter will accept input from the
# pipeline ByPropertyName
# 
# via a "get-help -full" of stop-process, it turns out the -name paraemter CAN accept pipeline input and it's ByPropertyName
# 
# As it turns out however this STILL won't work: get-service deals with service names while stop-process deals with 
# process names like svchost.exe. so the names are going to be incompatible 
# 
# to use more successful example, create aliases.csv with content:
# 
# Name,Value
# d,Get-ChildItem
# sel,Select-Object
# go,Invoke-Command
# 
# now i'll use import-csv to look at it:
Import-Csv .\aliases.csv
# 
# then pipe that to get-member to see that information
# 
# looking at the get-member of the above import-csv command
# and the help help of new-alias
# the types match up: name and value of import-csv are string types while new-alias has matching properties of type string
# Also looking at the help for new-alias, the -value string does in fact accept pipeline input ByPropertyName
# 
# All this means that is command DOES work:
# 
Import-Csv .\aliases.csv | New-Alias  # This example DOES work
# 
# 
################################### things not lining up, with custom properties
# 
# the examples in this section use New-ADUser which i don't have access to so i'll just write them out and use my imagination 
# 
# the above csv example is great but it's also convenient with property and parameter names convenient pre-lineup
# it's a little tougher when objects are creates elsewhere or data is produced by someone else
# 
# 
# New-ADUser has a few paraemters
# -Name (required)
# -samAccountName (no required but is need to make account usable)
# - department
# - city
# - title
# 
# all these paraemters accept pipeline input ByPropertyName
# 
# Example CSV file that is provided by doesn't match up: (newusers.csv)
# 
# login,dept,city,title
# DonJ,IT,Las Vegas,CTO
# GregS,Custodial,Denver,Janitor
# JeffH,IT,Syracuse,Network Engineer
# 
# the problem with this CSV file is is fields don't line up with what New-ADUser is looking for and some fields are missing (like samAccount)
# 
# instead of fixing it manually, could use the following:
Import-Csv .\aliases.csv | 
# >> select-object -propert *,
# >> 
@ {name='samAccountName';expression={$_.login}},
@ {label='Name';expression={$_.login}},
@ {label='Department';e={$_.Dept}}
# 
# disecting the syntax, here's what it means:
# 
# ---> select-object is used with tis -property parameter. this is started by specifying the "property *" meaning all existing properties.
# the * is followed by a comma meaning we're going to continue the list of properties 
# ---> the construct that starts with ${, ending with } is used used, creating a hash table. 
# a hash table consists of one or more key=value pairs. select-object actually looks for specific keys
# ---> select-object  first wants can be name, 'N' label or 'L' 
# the value for the key is the name of property we want to create 
# in the hash tables we create samAccount, Name and Department
# these all corresponed to the parameter names of new-aduser
# ---> select-object needs a second key, which can be Expression or "E"
# the value for this key is a script block, contained within {curley brackets}
# with that script block, $_ is used as a place holder of the existing piped-in object (in this case from the csv file)
# this is followed by a period, to connect it to the property. like object-dot-porperty notation, thus $_. followed by 
# login or Dept or whatever. this also on column of the CSV file.
# 
# the book says to "try it now" but despite very carefully typing it in i keep getting a parser error. I'm just going to move on
# 
# what this example did was take the contents of the CSV file and modified dynamically in the pipeline.
# the new output matches what the New-ADUser watns to see so we can now create new users by running
# 
# update: as it turns out i had skipped that first line, the select-object -property *,
# part. Adding that line in I got what I wanted:
PS P:\Repos\PowerShellFun> Import-Csv .\newusers.csv |
>> Select-Object -Property *,
>> @{name='samAccountName';expression={$_.login}},
>> @{label='Name';expression={$_.login}},
>> @{n='Department';e={$_.Dept}}
# 
# Which is a re-mapping of the csv data into the information/parameters i wanted
# 
# Adding 
New-ADUser
# to the ending would insert all that into the command 
# 
# ################################### paranthetical commands
# 
# there will be times no matter how hard you try the pipeline input can't be made to work
# using the Get-WmiObject command as an example, 
# the -ComputerName property has the "accept pipeline input" set to "false"
# meaning it can't accept computer names from the pipeline
# 
# we can get around this by using parantheses:
Get-WmiObject -Class win32_bios -ComputerName (Get-Content .\computers.txt)
# 
# this means it is going to run the get-content aginst computers.txt first, then do the get-wmiobject
# 
# since the -ComputerName parameter wants a value as a string, this will work
# 
# I didn't have a domain to test it with but I tried it anyway.
# it did seem to be looping through but it didn't work of course
# seems to be same error whether the host name existed on the network or not
# 
# note how there's not pipe involved, it's just two commands run on the same line, via parantheses
# 
# the paranthetical technique won't work if the command in parantheses isn't generating the exact type of object that the parameter
# expects. In that case things will require more manipulation 
# 
# 
################################### extracting value form a single property
# 
# the next example is of an object mis-match: 
# using Get-ADComputer in parantheses alongside the Get-Service -computerName cmdlet/parameter
# won't work because that -computername parameter wants string values while 
# get-ADComputer is producing ADComputer type objects so -computername won't know what to do with them
# 
# but ADComputer objects have a Name property
# so what is required is to extract the values of the objects' name properties and feed those values
# in this case computer names
# to the -computername parameter
# 
# select object can rescue us in this case:
# select-object includes an -expandProperty parameter which accepts a property name
# the cmdlet takes that property, extracts its values and returns those values as output of the select-object
# 
# the out of the example command will return a simple list of computer names:
Get-ADComputer -filter * -searchbase "ou=domain controllers, dc=company,dc=pri" | Select-Object -Expand name
# 
# the output can then be fed into the -computerName paraemter of any cmdlet that has a -computerName parameter
# such as get-service:
Get-Service -ComputerName (Get-ADComputer -filter * -searchbase "ou=domain controllers, dc=company,dc=pri" | Select-Object -Expand name)
# 
# for the next section, i created computers.csv:
# hostname,operatingsystem
# localhost,windows
# GALACTICAGAMER7,windows
# SERVER2,windows
# WIN8,windows
# CLIENT17,windows
# DONJOES1D96,windows
# 
# looking at the help for Get-Process, it has a -computerName parameter 
# that does accept pipeline input ByPropertyName
# it expects its input to be objects of stype String
# 
# using property extraction, is the way to go
# the import-csv custom PSObject isn't working quite right though
# 
# the hostname property contains text strings, so -ExpandProperty is able to expand those values into plain string objects
# which is what -ComputerName wants, thus:
Get-Process -ComputerName (Import-Csv .\computers.csv  | Select-Object -ExpandProperty hostname)
# 
# well get-process -computername seems to not work even with localhost so it's no wonder this doesn't work
# 
# not sure why it doesn't seem to try and loop through the text file though
# 
# this seems to be a slightly altered way of extracting the values of output from other commands
# different from parsing with awk or whatever but essentially doing the same thing
# 
# 
# 
#################################### chapter 9 lab 
# 
# ----> 1. would the follwing command work to retreive a list of installed hotfixes from all comptuers in the specified domain?
# explain why or why not
Get-HotFix -ComputerName (Get-ADComputer -filter * | Select-Object -expand name)
# 
# I actually didn't have to look this up: -computername is obviously going to be looking for a STRING
# while Get-ADCOmputer is going to be handing out objects of type ADComputer
# on the other hand...i assume name from get-adcomputer -filter * is going to be a string
# so now i'm not so sure
# I think I'm still goign to go with it not working ------> apparently it does work
# 
# ----> 2. Would this alternative command work to retreive a list of hotfixes from the same comptuers? explain why/why not
Get-ADComputer -filter * | Get-HotFix
# 
# as an alt way of providing a list of host names, I used this:
Import-Csv .\computers.csv  | Get-HotFix
# and it worked on the first entry of local host and errored on the rest as expected
# but then Get-ADComputer returns ADComputer Objects 
# and the computer name the get-hotfix is expecting is a string
# so really it will be an object mis-match
# 
# this one won't work
# 
# ----> 3. would this third version of the command work to retrieve the list of hotfixes from the domain PCs?
# explain why/why not
Get-ADComputer -filter * | Select-Object @{l='computername';e={$_.name}} | Get-HotFix # 'l' I beleive is short for label
# 
# I believe this would not work because i have no reason to think the Get-ADComputer -filter * computer objects returned
# would have a label of 'computername' and computername.name hardley makes sense
# so i don't think a list of computer in string format would then supplied to get-hotfix at the end
# ------------> this one will work
# 
# ----> 4. write a command that uses pipeline parameter binding to retreive a list of running processes 
# from ever PC in an AD domain, without using parantheses
# 
# using prior example i could start out with
Get-ADComputer -filter * # return list of AD computer objects
# then pipe that to select-object -expand name
Get-ADComputer -filter * | select-object -expand name # should list names of computers from comptuer objects as string types
# 
# theoretically i should be returning all the comptuer object name properties as string types now
# 
# assumign this is correct it just has to be piped into or out of get-process:
# 
Get-ADComputer -filter * | select-object -expand name | Get-Process
# 
# no idea if that's right. but i'm going to go with it
# 
# 
# ----> 5. write a command that retreives a list of intalled services from every PC in an AD domain.
# this time don't use pipeline, use parantheses
# 
# I did have to look at the answer for this. the question says not to use "pipeline input" which is different
# from not using any pipelines at all...
# 
# there's the thing about the AD domain there so I know 
Get-ADComputer -filter *
# will be involved in some way
# so first put in the 
Get-Service -ComputerName
# then add in the AD portion in paranthesis
# Get-Service -ComputerName (Get-ADComputer -filter * 
# then pipe that over to select object with its expandproperty and name
# so all together:
Get-Service -ComputerName (Get-ADComputer -filter * | Select-Object -ExpandProperty name)
# 
# 
# 
# ----> 6. would the follwoing work to retreive info from every pc in the domain?
Get-ADComputer -filter * | select-object @{l='computername';e={$_.name}} | Get-WmiObject -Class win32_bios
# 
# this wouldn't work: get-wmi-object's comptuername parameter doesn't take any pipeline binding
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
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
