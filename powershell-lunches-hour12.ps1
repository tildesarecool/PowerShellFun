# ################################### 22 May 2019 ######################################################### 
# 
# chapter 12: A more practical approach
# 
# This chapter won't have anytying new, it will just be examples of what's been covered so far. 
# it will consist of a task and steps to complete it
# 
# this will actually be with PS v5 and win 10, amazing
# 
# goal: use PS to modify some of the default user privleges on the local system. 
# not necessarily permissions but system-wide tasks that a user or group has the ability to perform
# 
# ################################### 12.2 "finding commands"
# 
# This section seems to be about logically going though and finding appropriate commands with the help system
# 
# since the scenario outlined involves privileges, it first suggests
# help *privilege*
# which doesn't return anything
# 
# then
# get-command -noun *priv* is tried 
# also of no help
# 
# this is where the PowerShell gallery and "find-module" is suggested:
Find-Module *privilege* | format-table -AutoSize
# the book only shows one results but now days there's two results
# doesn't matter though the books result is more fitting for the scenario:
# PoshPrivilege
# So:
install-module PoshPrivilege
# This actually prompted me to update the NuGet version to the latest
# then a prompt to trust an untrested provider, PSGallery
# then an prompt of whether i'm sure i want to install the thing i told it to install
# but i have it now. probably.
# 
# next is looking at the commands this has given us:
get-command -Module PoshPrivilege | Format-Table -AutoSize
# 
# CommandType Name              Version Source
# ----------- ----              ------- ------
# Function    Add-Privilege     0.3.0.0 PoshPrivilege
# Function    Disable-Privilege 0.3.0.0 PoshPrivilege
# Function    Enable-Privilege  0.3.0.0 PoshPrivilege
# Function    Get-Privilege     0.3.0.0 PoshPrivilege
# Function    Remove-Privilege  0.3.0.0 PoshPrivilege
# 
# seeing this, the next step is figuring out how to use them to add or enable a privilege
# 
# 
# 
# ################################### 12.3 learning to use commands
# 
# The next step is to try help with add-privilege:
help Add-Privilege
# 
# looking at this, it looks like a user or group name is provided via -AccountName
# and then one or more privileges are provided by name
# 
# since we don't know the names we get use help with get-privilege, first by just running it alone
get-privilege
# this give a lot of output
# 
# to narrow it down and utilize add-privilege:
# 
Add-Privilege -AccountName administrators -Privilege SeDenyBatchLogonRight
# 
# 
# To review the steps for what was necessary:
# 
# 1. searched local help system for anythying that contained a specific keyword related to the task.
# then searched of all the help files contents for the keyword 'privilege' 
# 
# 2. then moved on to search specific command names to try and find commands for which no help files were installed.
# 
# 3. when nothing was found locally, the PS repository, PSGallery was queried and a match came up. 
# this was installed and the commands reviewed 
# 
# 4. thanks to the author's help files, the command was able to give us a list of privileges 
# from which we could determine the data structure and values the command would expect
# it is a good idea to start with a Get- command when avialble to see what things look like
# 
# 5. using the gather information, the command was used to complete the task/scenario
# 
# 
# ################################### 12.4
# 12.4 seems less important as it's just general tips about not giving up and having patients when things won't work
# 
# 
################################### chapter 12 lab
# just the one exercise
# but it suggests a VM which i don't have handy
# 
# task:
# create a directory called LABS and share it
# assume the folder and share don't arleady exist
# don't worry about ntfs permissions; make sure that the share permissions are set so that everyone has read/write access
# and local admin have full control
# since the share will be primarily for files, "may" want to set the share's caching mode for docs
# the script should output an objecting showing the new share and its permissions
# 
# 
# 
Add-Privilege -AccountName everyone -Privilege read,write 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
#################################### 22 May 2019 ######################################################### 