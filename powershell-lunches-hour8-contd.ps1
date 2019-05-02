# ################################### 30 april 2019 ######################################################### 
# 
# chapter 8: objectifying powershell
# 
# for later merging with the other hour 8 ps1 file
# 
# 
# the properties, methods and anything else attached to an object are 
# generically called its "members"
# get-member is fact getting a list of all the objects' members
# but it's singler member, per PS convention
# 
# ############################ using object attri butes or properties
# 
# looking at the output of get-member, there are several varieties of properties:
# --> ScriptProperty
# --> Property: always contains a value, describe something about an object (status, ID, name). are "often" read-only
# --> NoteProperty
# --> AliasProperty
# 
# ------------===> above and beyond
# the PS shell "dynamically adds" other properties as necessary
# such as above scriptproperty/propert/noteproperty/aliasproperty
# but those are not documented any splace in PS help or on the MSDN doc page
# this is via the "Extensible type system (ETS)"
# 
# The ETS will do this to make objects more consistent such as adding a name property
# to objects that that might only have a variation of that like "ProcessName"
# and sometimes it's to expose information in the object like scriptproperties for the
# process object
# ------------===> above and beyond
# 
############################ object actions or methods
# 
# this section only says object methods are a thing in PS as are events
# but that those won't be mentioned at all in the book as they are unnecessary
# are requires more extesnive .NET knowledge than the book will cover
# and piping in multiple cmdlets will accomplish the same thing
# 
############################# sorting objects
# 
# Most PS cmdlets produce objects "deterministically"
# e.g. in the same order every time it is run
# services and processes are always by alphabetical while event logs are always chronilogical for instance
# 
# the cmdlet 
Sort-Object
# can be used to specify a specific order, such as get-process in order of virtual memory usage:
Get-Process | Sort-Object -Property VM
# i ran this but i can't tell that it's sorted my virtual memory usage. unless that's a missing column
# 
# actually the mentions this. 
# using the alias 'sort' and abbreviating the parameter descending, the command comes back:
Get-Process | sort VM -Desc
# still unclear on the table i'm seeing but i'm getting the gist
# 
# futher variation on this:
Get-Process | sort VM,Id -Desc
# 
############################# selecting desired properties
# 
# in order to show extra (or trim off unneeded) columns of data - e.g. properties - output from a cmdlet
# the cmdlet can be piped into 
Select-Object
# this is useful with Convert-ToHTML that outuputs everything by default into an HTML format
# this string of pipes for instance
Get-Process | Select-Object -Property name,Id,vm,Pm | ConvertTo-Html | Out-File test2.html
# takes a few properties and generates HTML and creates an HTML file. As it implies
# and this can be shortened:
# Get-Process | Select name,Id,vm,Pm | ConvertTo-Html | Out-File test2.html
# which i guess is good to know
# 
# ------------===> above and beyond
# select-object has a -first and -last parameter for keeping the first/last number of specified rows of information
# 
Get-Process | Select-Object -Property name,Id,vm,Pm -Last 10
#  very simply lists the last ten lines in what would otherwise be the whole list of rows
# not sure if this is comparable to top and tail in bash
# book does not mention tail/top, i was just wondering about that
# 
# ------------===> above and beyond
# 
# last note is the complement to select-object, where-object
# select-object chooses properties/columns while where-object removes objects from the pipeline
# 
############################# till-the-end objects
# 
# The PS pipeline contains objects until the last command has been executed
# once that is complete, PS looks to see looks at the various config files to see which 
# properties to use in contsructing the onscreen display, also deciding whether that display will be 
# a table or a list based on internal rules and on config files
# 
# using the example 
# 
Get-Process | 
Sort-Object VM -Descending |
Out-File .\procs.txt
# 
# get-process puts process objects into the pipeline,
# next sort-object only changes the order of the objects; the pipeline still contains the processes
# lastly is out-file which is where PS produces the output by taking those processes
# and formatting them according to its itnernal ruleset
# the results of all this are then sent to the specified file
# 
# next example:
# 
Get-Process | 
Sort-Object VM -Descending | 
Select-Object Name,Id,VM
# 
# get-process puts process objects into the pipeline
# sort-object the puts those same process object into the pipeline newly sorted
# 
# but select-object does something a bit differnet: if select-object removed properties 
# the object in the pipeline would no longer be a process objects
# so instead select-object creates a new custom object:
# PSObject
# the properties request from the processes object are copied over and then that is put into the pipeline
# 
# as this is a custom PSObject there is no default configuration for PS to refer back to
# thus it will take its "best guess" and make assumptions on formatting the data into a table as
# best it can 
# 
# the objects that wind up in the pipeline can be viewed with get-member:
Get-Process | Sort-Object VM -Descending | Select-Object Name,Id,VM | gm
# comparing this to
Get-Process | Sort-Object VM -Descending | gm
# does indeed produce much different output in that the select-object version
# only has about 7 lines of output whre the non-select-object version
# has 30+ lines
# 
# to further demonstrate the customized object concept, can try:
Get-Process | gm | gm
# 
# the book keeps mentioning the "TypeName" part of the gm output but
# never quite goes into any explanation of it
# that double gm commad produce a "TypeName" of 
#  TypeName: Microsoft.PowerShell.Commands.MemberDefinition
# which I guess is noteworthy and important for unspecified reasons
# 
# objects passed down the pipeline and the object types have to be tracked to make sure they'll work
# with each other, which gm can help with
# 
################################### chapter 8 lab 
# 
# --> 1. identify a cmdlet that produces a random number
# it would appear that running
Get-Random
# without any parameters or anything produces a random number
# 
# 
# --> 2. identify a cmdlet that displays the current date/time
# it would appear
Get-Date
# shows both date and time (also day of week)
# 
# --> 3. what time of object - the "TypeName" - does the cmdlet Get-Date produce?
# it would appear  System.DateTime
# 
# 
# --> 4. using Get-Date and select-object, display only the current day of the week in a table like:
# DayOfWeek
# ---------
#    Monday
# 
# had to look at the answer to this one. I'm sure it was explained and really obvious but apparently you get this 
# exactly output with the following:
Get-Date | Select-Object DayOfWeek
# 
# 
# --> 5. identify a cmdlet that displays info aout installed hotfixes 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
#################################### 30 april 2019 ######################################################### 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
