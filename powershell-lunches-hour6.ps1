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
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
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
