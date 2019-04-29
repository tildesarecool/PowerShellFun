# ################################### 28 april 2019 ######################################################### 
# 
# chapter 6: connecting via pipes. like mario. like super mario.
# 
# commands connect to each other via the "pipeline" (like mario)
# 
# piping allows for for one command to pass its output to another command via a pipe
# 
# side note, the CMD shell has some rudimentary support for this. 
# 
# systeminfo | find /i "BIOS Version"
# 
# for instance. and ask the book points out dir | more is a common one.
# 
#
####################################
# exporting to csv, xml or json
# 
# this book is based around PS 3 which apparently pre-dated json support. so as i noted to myself there's also a json  thing
# with new versions of PS like mine, v5
#
# slight update: i thought json was export option same as csv/xml but it looks like it's actually more of an import/export of json files for
# objects the same way c# or python can import/export objects to a json file
#
# 
# as suggested, i ran 
Get-Process # along with gps
# then 
Get-Service # alongside gsv
# and finally 
Get-EventLog Security -Newest 100
# 
# 
#################################### exporting to csv
# 
# exporting get process to csv:
Get-Process | Export-Csv process.csv
# 
# I opened the csv file and it is indeed a big mess of a file
# 
# the first line in the csv file is "#TYPE System.Diagnostics.Process"
# which "identifies the kind of infomration included in the file"
# the line under that contains the column headers
# 
# [almost] any command that starts with "Get-" can be exported to a csv file.
# the generated csv file from get-process contains a lot more information than what is typically 
# shown as out put to the screen
# 
# The csv file can be emailed some place else and then imported with 
 import-csv process.csv
# for instance. it would just be a snapshot from that time it was exported
# 
# 
#################################### exporting to xml (CliXML technically)
# 
# 
# the xml generated, CliXML, is unique to powershell but standard enough 
# any xml reader should be able to deal with it
# 
# the commands, like the csv one, are Export-Clixml and Import-Clixml
# 
Get-Process | Export-Clixml process.xml
# 
# Wow. the xml file is 55 MEGABYTES, while the csv is only 183KBs. 
# ya i'm not trying to open that xml file
# nor will I bother to export services or the eventlog thing. 
# and I think i'll skip importing too, not much point
# 
# since i was sure i had read json was an additonal option and book suggested finding other import/export options
# I tried 
Get-Help json
# and got this back
# ConvertFrom-Json                  Cmdlet    Microsoft.PowerShell.U... Converts a JSON-formatted string to a custom object.
# ConvertTo-Json                    Cmdlet    Microsoft.PowerShell.U... Converts an object to a JSON-formatted string.
# 
# so the data doesn't necessarily export to json in the same sense that get-process exports to csv
# 
# I did try
Get-Command -verb export
# and I do see some interesting entries that seem like they're worth exploring. Like export-windowsdriver for instance
# 
# 
# 
#################################### comparing files
# 
# the command suggested is 
Compare-Object # included alias is "diff"
# 
# The scenario sited for using this would be having two computers
# one that you want to model computers after
# and a computer you want to compare that against
# so you can export the processes on the 'reference' PC as an xml file
# then use diff to compare the process on the second pc 
# to compare running process between the two
# as in: 
# diff -reference (Import-Clixml) -difference (Get-Process) -Property name
# 
# the reference/difference parameters here are actually abbreviated for reference/differeneceobject
# 
# since the 'property' name is specified it's comparing the name between the two 
# 
# the differences will be specified by <= indicator for the left and a => for the right side
# 
# the only second  PC i had handy was my win 7 one
# so i ran the command
Get-Process | Export-Clixml process(win7).xml
# on that one as well as my current win 10 one
# i then copied that process win 7 xml file over to my local c:\labs
# as it turns out I don't need the win 10 xml file but
# I ran the command
diff -reference (Import-Clixml '.\process(win7).xml') -DifferenceObject (Get-Process) -property name
# which just does a get-process against the local machine and compares it versus the reference
# which in this case is the process(win7).xml
# and of course it's going to have differences, they're two different OSes
# 
# and indeed running the commadn without the name part
diff -reference (Import-Clixml '.\process(win7).xml') -DifferenceObject (Get-Process)
# does have many more things listed and seems worthless as output
# 
# while i was reading this I thought the author was leading more towards a 
# here's how to export a config from one PC and import to another, to setup lots of 
# PCs with one particular set of settings and configs. but that's not where it went
# 
# 
#################################### piping to a file or a printer
# 
# for backwards compatibility and familiarity, the '>' can be used for redirection, like
# dir > dir.txt
# or whatever
# but really this is an abstraction for 
dir | Out-File directory-list.txt
# 
# the book mentions using the pipe/outfile sytax instead of '>' because there are additional
# options with out-file such appending files
# *cough, what about >> *cough
# and specifying column widths. seems like slim reasons to me
# 
# i did as suggested and ran 
help Out-File
# looking for the way to specify the column widith. I think it's -width. that's it. -width and an integer
# 
# similarly dir is really an abstraction for 
# dir | outdefault
# which is actually a further abstraction for 
# dir | outdefault | out-host
# 
# 
Get-Command -verb out
# provided me with:
# CommandType     Name                                               Version    Source
# -----------     ----                                               -------    ------
# Cmdlet          Out-Default                                        3.0.0.0    Microsoft.PowerShell.Core
# Cmdlet          Out-File                                           3.1.0.0    Microsoft.PowerShell.Utility
# Cmdlet          Out-GridView                                       3.1.0.0    Microsoft.PowerShell.Utility
# Cmdlet          Out-Host                                           3.0.0.0    Microsoft.PowerShell.Core
# Cmdlet          Out-Null                                           3.0.0.0    Microsoft.PowerShell.Core
# Cmdlet          Out-Printer                                        3.1.0.0    Microsoft.PowerShell.Utility
# Cmdlet          Out-String                                         3.1.0.0    Microsoft.PowerShell.Utility
# 
# not sure any of these look that interesting but maybe in conjunction with others it could be
# 
# 
Get-Service | Out-GridView
# 
# actually opens somehing of a GUI screen that just displays all the services, their start/stopped status and the display name
# seems read-only to me. ot sure how it's useful yet. I'm sure it'll be clear later
# 
# 
# seems like very little out the printer thing. not sure why it's even mentioned. and also no reason to bother
# 
# 
# 
#################################### converting to html via ConvertTo-Html
# 
# I tried running
Get-Service | ConvertTo-Html
# screen flooded with html strings. thanks.
# 
# the book suggests
Get-Service | ConvertTo-Html  | Out-File servicesalso.html
# which is a nice double-piper command, a term i just made up because it sounds dirty
# but this version
Get-Service | ConvertTo-Html  > services.html
# is exactly equivalent and i can't see a reason to not use but whatever
# 
# 
#################################### killing processes and stopping services
# 
# 
# an especially super great command that shouldn't be run is
Get-Process | Stop-Process
# as implied it goes through and stops all processes on the whole system
# 
# a much more useful form of this would be to stop a specific process:
Get-Process -name notepad |Stop-Process
# 
# and ya, that is quite effective and instantanious
# 
# similiarly, Get-Service can be used in the same way by piping to stop, start and set-service
# i tried theis with themes:
Get-Service -name themes | Stop-Service
# 
# nothing really changed on screen. but the status is now stopped
# 
# cmdlets that modify the system in some signicant way like stop-service and stop-process
# adhere to an "impact level" which by default is "high" and can't be changed
# to see the current setting of the shell, use
$confirmpreference
# which will say "High"
# anything with a higher impact than the setting reported by $confirmpreference
# will force an "are you sure?" prompt
# which can be overridden with
# -confirm
# 
# any/all cmdlets that support -confirm also support -whatif, to run a thing and see what results "would be" 
# without actually running it:
Get-Service -name themes | Stop-Service -WhatIf
# 
# 
# pff. not even trying it with -whatif
# as a side note, get-content already has the two alias: type and cat
# 
#################################### clarifications on get-content versus import
# 
# 
# after exporting some output to either CSV or XML there may be a question on reading it back in:
# is there a difference between get-content versus import-csv in other words
# the answer is the get-content will just stream an entire CSV file across the screen as it is in the text file
# no formatting or intepretation in other words
# while import-csv for instance would actually intepret and parse the entire file by format to create a much
# more friendly format
# 
# moral is when the data doesn't need intepretation use get-content, otherwise use import-
# 
#################################### chapter 6 lab ####################################
# 
# 
# 1. create two separate/different text files: compare them using diff. that's it. 
# 
# I created a couple of text files around the output of "systeminfo" and ran: 
diff -ReferenceObject (Get-Content '.\alltheinfo - Copy.txt') -DifferenceObject (Get-Content .\alltheinfo.txt)
# i think i like this diff thing
# 
# 2. what happens when running this command and why?
Get-Service | Export-Csv .\services.csv | Out-File
# 
# there's an error message about the path argument being "null". i think it means the path argument is required
# 
# 3. what ways are there to specify a service to stop with stop-service besides piping in names of services?
# is there a way to stop a service without using get-service at all?
# 
# yes, it is possible to stop a service without get-service using -name
Stop-Service -name themes
# for instance will do it. there's both a display name as well as just a name
# 
# 
# 4. using export-csv, what parameter would be passed in to make it a "pipe delimited file" ?
# 
# looks like there's a -delimeter parameter. I ended up using quotes, but this works:
Get-Process | Export-Csv process.csv -Delimiter "|"
# 
# 5. is there a way to export a csv file without that top # comment with the type info as an option?
# 
# I found that there's a -notypeinformation parameter and this appears to have worked. I just used a variation on the last command:
Get-Process | Export-Csv process.csv -Delimiter "|" -NoTypeInformation
# 
# 
# 6. for export-clixml and export-csv, which both over-write files by default, what parameter would ask for confirmation before over-writing?
# and which would outright prevent the overwriting without asking?
# 
# there's a -confirm for asking for confirmation and a -noclobber for outright prevention without asking. 
# as a bonus there's also -force
# 
# 7. what is the parameter to pass to export-csv to tell it use the system default seperator in cases where that may not be a comma?
# 
# the -UseCulture [<SwitchParameter>] appears to be it, with this description:
# Indicates that this cmdlet uses the list separator for the current culture as the item delimiter. The default is a comma (,).
# 
# 
# 
#################################### chapters 1 - 6 review labs ####################################
# 
# there's 18 of them. i'll do them tomorrow
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
#################################### 28 april 2019 ######################################################### 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
