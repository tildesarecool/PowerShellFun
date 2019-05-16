# ################################### 4th and 5th May 2019 ######################################################### 
# 
# chapter 10: formatting
# 
# when running a command like get-process the header width and other formatting
# is defined by the xml file DotNetTypes.format.ps1xml <-------------------------- ps1xml is the file type. not ps1.xml. ps1xml
# all the width, alignmnt etc
# 
# DotNetTypes.format.ps1xml is stored in the PS install folder which can be access via $pshome
cd $PSHOME
# which for me lead to 
# C:\Windows\System32\WindowsPowerShell\v1.0>
# 
# to find how a process is displayed by default, we have to start with finding the type of object get-process returns
# 
get-process | gm
# 
# then:
# 
# do a find in notepad for System.Diagnostics.Process to bring that up in notepad
# ---> keep clicking next until System.Diagnostics.Process is found in the xml file
# apparently the one i wanted was under the <Name>process</Name> tag
# 
# formatting-wise, here is what happens the get-process is run:
# 
# ---> 1. cmdlet places objects of the type into the pipeline, in this case System.Diagnostics.Process type
# 
# ---> 2. After all the commands have run, the invisible always-there cmdlet Out-Default is run. it picks up whatever objects are in the pipeline
# 
# ---> 3. Since PS is made to use the screen as the default output, out-default passes the objects to Out-Host. 
# out-host is implied default output to the screen versus files or a printer
# 
# ---> 4. when objects are passed to out-host it passes them to the formatting system as 
# most out-* cmdlets are incapable of working with standard objects, instead made to work with special formatting instructions
#  
# ---> 5. the formatting system looks at the type of oject and follows an internal set of formatting rules (using an XML file that 
# defines this). 
# using the rules to produce formatting instructions, these are passed back to out-host. 
#
# ---> 6. Once out-host gets the formatting instructions, it uses those to assemble the onscreen display
# 
# basically, when when a command is run along with an out- cmdlet, such as
Get-Process | Out-File procs.txt
# the out-file will it has been sent some normal objects, which it will pass to the formatting system. 
# that formatting system will create the formatting instructions and pass them back to out-file to create formatting based on the instructions
# 
# the formatting system looks for predefined views for the target object it's dealing with. 
# in this case System.Diagnostics.Process
# 
# No pre-dfined view...THE SECOND FORMATTING RULE
# 
# For instance
Get-WmiObject win32_OperatingSystem | gm
# 
# the type returned, 
# System.Management.ManagementObject#root\cimv2\Win32_OperatingSystem
# is defined in the xml file DotNetTypes.format.ps1xml
# 
# when the formatting rules are not found in DotNetTypes.format.ps1.xml
# the formatting system falls back to the defaults defined in types.ps1xml
# 
# inside types.ps1xml will be an entry for defaultdisplaypropertyset with the six properties
# 
# running
Get-WmiObject win32_OperatingSystem
# will use those six listed properties
# 
# 
# THE THIRD FORMATTING RULE: the kind of output to create
# 
# if the formatting system uses four or fewer properties it uses a table
# 
# five or more properties it uses a list
# 
# the six properties of Get-WmiObject win32_OperatingSystem triggers a list instead of a table
# 
# 
# column headers, as listed from a Get-Process for instance, are not always accurately 
# reflective of of the underlying property names; only a pipe to get-member can accurate show that info
# 
# 
# 
# 
################################### FORMATTING TABLES
# 
# 
# 
# Over-riding the defaults....
# 
# there are four cmdlets for formatting (only 3 of which really matter)
# 
# 
# 
############## format-table
# 
# some of the more useful parameters:
# 
# --> -autosize 
# forcess PS to try to size each column to hold its contents and no more
# thus making the table "tighter" in appearace
# but also making it take more time to produce output
# 
# 
# --> -property
# this parameter acepts a comma-separated list of properties that should be included in the table
# and will use the casing provided (cpu vs CPU)
# this will accept wild cards
# it will only display properties that can fit in the table so not all the properties specified may display 
# parameter is positional so doesn't have to type the parameter name, just put the property list in the first psoition
get-process | Format-Table ID,Name,Responding -AutoSize
# 
# 
# --> -groupBy
# generates a new set of column headers each time the specified property value changes
# this will only work when the objects have been first sorted on the same property
Get-Service | Sort-Object Status | Format-Table -GroupBy Status
# 
# this generates a list of status stopped services followed by a list of status running
# 
# --> -wrap
# usually when the shell has to truncate information in column it will insert an elipsis
# to indicate it couldn't fit the extra information but there is extra information
# wrap will have the information inlcuded but make the much longer as it displays all the information
# 
# this demonstrates:
Get-Service | Format-Table name,status,DisplayName -AutoSize -Wrap
# 
# 
# 
################################### FORMATTING LISTS
# 
# 
# format-list - alias 'fl' - can be used to display more information horizontally in a table 
# 
# format-list supports some of the same parameters as format-table, such as -proprty
# 
# similar to 'gm', format-lis twill also display the values for those properties so you can see what kind of info each property contains
# such as:
Get-Service | format-list *
# 
# 
# 
# 
################################### FORMATTING WIDE LISTS
# 
# 
# The cmdlet format-wide - alias fw - displays a wide list.
# will only display the values of a single property so its -property accepts only one property name, not a list
# it will not accept wild cards
# 
# by default format-wide will look for an object's name property
# generally it will default to two columns but -columns parameter can be used to specify more columns:
Get-Process | Format-Wide name -col 4
# 
# 
# 
################################### creating custom columns and list entries
# 
# format-list and format-table can use the same constructs to create custom table columns and list entries 
# via that hash table notation 
# to add custom properties to an an object
# 
# for instance:
Get-Service | Format-Table @{name='ServiceName';Expression={$_.Name}},Status,DisplayName
# 
# sample of output
# ServiceName                                             Status DisplayName
# -----------                                             ------ -----------
# AJRouter                                               Stopped AllJoyn Router Service
# ALG                                                    Stopped Application Layer Gateway Service
# AlienFusionService                                     Running AlienFusion Windows Service
# 
# 
# 
# 
# 
Get-Process | Format-Table Name, @{name='VM(MB)';Expression={$_.VM / 1MB -as [int]}} -AutoSize
# 
# 
# explainer of above:
# 
# ---> get-process is being piped to format-table, which wants to display the VM property in bytes (as reported if you pipe it to fl *)
# ---> we're having format-table start with the process's Name property
# ---> then the hash table notation is used to create a cusotm column that will be labeled "VM(MB)"
# this is followed by what could be a definition of a value or an expression for that column by taking the normal VM property and 
# dividing it by 1MB, using teh slash for the div operator
# PS will recognize the shortcuts: KB, MB, GB, TB and PB
# ---> the -as parameter change the data type to an integer, cutting off the resulting decimal. PS rounds/up down as appropriate
# ---> also, all the normal operators can be used: *, +, - in addition to / are all that are mentioned (what, no modulo?)
# 
# the format-* cmdlets can handle keys that are intended for controlling the visual display 
# in addition to the ones supported by select-object: label, name and expression
# 
# additional include:
# --> FormatString - specifies a formatting code causing the data to be displayed according to the specified format
# (mainly useful for numeric and date data)
# --> Width - specifies desired column width
# --> Alignment - specifies the desired column alignment of left or right
# 
# using these keys, it is easier to achieve the prior example results
Get-Process | Format-Table Name, @{name='VM(MB)';Expression={$_.VM};FormatString='F2';align='right'} -AutoSize
# 
# 
################################### Going out: to a file, a printer or a host (10.7)
# 
# By default, the format-* cmdlets will automatically go to out-default which goes to out-host which puts it up on the screen.
# For instance:
Get-Service | Format-Wide
# Using this command and piped to out-host will do the exactly same thing
# this is what makes the difference with out-file and out-printer: directing out put to other non-screen sources like like a file or a printer
# 
# out-printer and out-file default to a specific character width, which means what is generated may look different then the screen output
# to correct this, both cmdlets have a -width parameter than enables changes to the output width
# 
################################### Another out: gridviews (10.8)
# 
# out-gridview - another form of output, which bypasses the formatting system. It can only receive regular objects output by other cmdlets.
# when it is run:
# no format-* cmdlets are called
# no formatting instructions are produced
# no text output is displayed
# out-gridview can't receive output of a format-* cmdlets
# 
# out-gridview will accept only standard objects and won't accept formatting instructions
# 
# these two commands demonstrate the point with out-gridview
# 
Get-Process | Out-GridView
Get-Process | Format-Table | Out-GridView
# 
# The first one generates this GUI subwindow and the second one just throws an error
# 
################################### always format right 10.9.1
# 
# the format-* cmdlets should always be the last thing on the command line (except things like out-file and out-printer)
# it is last/on the right so that it can directly to the auto-included out-default and out-host which will take in the formatting instructions
# 
# the command 
Get-Service | Format-Table | gm
# demonstrates this (all the typename lines end in ".format.format-something")
# when running the above gm isn't displaying info about your service objects
# because the format-table cmdlet doesn't output service objects
# it consumes the service objects you pipe in and it outputs formatting 
# instructions which is what gm sees and reports on
# 
# on the other hand, if you run this:
Get-Service | select name,DisplayName,Status | Format-Table | ConvertTo-Html | Out-File .\services.html
# 
# the results won't be quite what is expected:
# instead of objects being piped to convertto-html formatting instructions were piped to convertto-html
# this is a good demonstration of why the format-* cmdlets have to be at the end of second to the end of 
# any given command that is run
# 
# 
# 
# 
################################### One object type at a time 10.9.2
# 
# It is best to avoid putting multiple kinds of objects into the pipeline.
# 
# the formatting system looks at the type of the first object inserted into the pipeline
# and determines the formatting based on that object type
# 
# insert mutliple object types and output may not be comlete or useful
# 
# 
# an example of what happens when two objects are sent to the pipline is using two commands in one line with a semicolon:
Get-Process; Get-Service
# 
# the get-process object displays as expected but when it comes time for the get-service
# it displays in more of list format than a the normal multiple column format which usual:
# 
# sample:
# 
# 
# Status      : Running
# Name        : WpnUserService_aa85d
# DisplayName : Windows Push Notifications User Service_aa85d
# 
# 
# Status      : Running
# Name        : wscsvc
# DisplayName : Security Center
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
#################################### chapter 10 lab
# 
# ---> 1. display a table of process that includes only the process names, IDs and whether they're repsonding to windows (the responding proeprty has that info)
# have the table take up as little horizontal room as possible, but don't allow any info to be truncated
# 
# well i know get-process is going to be involved as is format-table
# probably somewhere around this:
Get-Process | Format-Table ID,Name,Responding -AutoSize -Wrap
# 
# 
# 
# ---> 2. display a table of processes that includes the process names and IDs also include columns of virtual and phsycial memory usage, expressing values in MBs
# 
# this command probably has something to do with it:
# Get-Process | Format-Table ID,Name, @{name='VM(MB)';Expression={$_.VM / 1MB -as [int]}}, Expression={[int]($_.NPM/1024)}}, @{Label="PM(K)";Expression={[int]($_.PM/1024)}}
# 
# I'm almost positive this is it
Get-Process  | sort VirtualMemorySize -Descending | Format-Table  ID,Name, @{name='VM(MB)';Expression={$_.VM / 1MB -as [int]}}, @{Label='PM(MB)';Expression={$_.PM / 1MB -as [int]}} 
# 
# 
# ---> 3. use get-eventlog on windows to display a list of available event logs (hint: you need to read the help to learn correct parameter to accompolish)
# format output as a table that includes in this order the log display name and retention period. the column headers must be logname and retdays
# 
# I found the wording of this confusing so i just looked it up:
Get-EventLog -List | Format-Table @{l='logname';e={$_.LogDisplayName}},@{l='retdays';e={$_.minimumretentiondays}} -AutoSize
# 
# 
# 
# ---> 4. display a list of services so that a seperate table is displayed for services that are started and services 
# that are stopped. services that are started should be displayed first (hint: use -groupby parameter)
# 
# probably involves Get-Service | format-list * 
# in some way
Get-Service | format-list -GroupBy started
# at least does started first and stopped last, not really a table though and there are other statuses
# 
# Get-Service | select name,status | Format-table @{name='ServiceName';Expression={$_.Name}},Status -groupby started
# 
# Get-Service | select name,DisplayName,Status | Format-Table
# 
# wasn't having that much luck with this one so i finally looked it up. seems much simpler than i was making it:
Get-Service | sort Status -Descending | Format-Table -GroupBy status
# 
# 
# 
# 
# ---> 5. display a four-column-wide list of all directories in the root of C: drive. 
# 
# wasn't sure how to look at the filesystem like this. but there were examples about the file system in the chapter I forgot about
# so anyway answer:
dir c:\ -Directory | Format-Wide -Column 4
# 
# 
# 
# ---> 6. create a formatted list of all .exe files in c:\windows displaying the name, version info, and file size. PS uses 
# the length property but to make it clearer your outoput should show size.
# 
# 
# The word of this I found confusing. maybe if the chapter were more fresh in my memory.
# anyway i looked the answer of this up as well
# 
dir C:\Windows\*.exe | Format-List Name,VersionInfo,@{name="size";expression={$_.length}}
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
#################################### 4 and 5th May 2019 ######################################################### 
# 
