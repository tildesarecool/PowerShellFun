# ################################### 14 May 2019 ######################################################### 
# 
# chapter 11: filter and compare
# 
# There are two models of narrowing results in PS and both are generically referred to as "filtering"
# 
# the first model, e.g. "early filtering": attempt to instruct the cmdlet you're using to only get the information specified. The ideal approach is this one
# this could be as simple as telling the cmdlet what you're looking for
# 
# using get-service as an exmaple:
Get-Service -name e*, *s*
# this has the limitation of not return more specific things like only services that are running regardless of name
# because there is not parameter to supply that
# 
# "filtering left" (we're still on first model? same as "early filtering"? no idea)
# 
# filter left means putting filter criteria as far left/at start of command line as possible
# this front loading means the the initial cmdlets do more of the owrk taking the burden off the cmdlets fartehr out
# this is to cut down on the burden of computers on a network and what those network PCs may do to burden the local PC
# 
# The disadvantage of this "filter left" technique is that every single cmdlet can specify its own method of filtering
# each according to its abilities
# 
# To be really affective with the filter-left technique a lot of knowledge about how the various cmdlets operate is required
# but it will still come out to better performance.
# 
# 
# the second model: in an iterative approach, take everything the cmdlet returns and uses a second cmdlet to filter out 
# what is not needed
# 
# 
################################### 11.3 - comparison operators
# 
# to use the where- object you have to know how to tell the shell what is needed to filter through comparison operators
# 
# in some but not all "filter left" techniques; the -filter parameter of many Get-* cmdlets for instance, uses the same comparison operators
# but other cmdlets - like get-wmiobject (covered in future chapter) - use an entirely different filtering and comparison language 
# 
# the rest of this paragram seems to be about comparisons and booleans operators, true/false etc.
# and obviously these are not case sensitive
# 
# short comparison operators:
# 
# -eq is equals
# -ne not equals
# -ge and -le are greater than or equal to and less than or equal to
# -gt and -let are greather than and less than
# 
# string comparisons have default case insensitive and case sensitive-specific:
# 
# case sensitive: -ceq, -cne, -cgt, -clt, -cge, -cle
# 
# boolean -and and -or are also there as as well as a -not. an ! can be used in place of a -not
# 
# example: test whether a process isn't responding also using the $_ as a place holder for the process object
# $_.Responding -eq $False
# 
# PS defines $False and $True to represent True and Flase boolean values (okay feels like i'm missing something there)
# 
# other comparison operaters:
# -like: accepts * wildcards, allows for comparison to see if "Hello" -like "*ll" 
#      reverse of this is -notlike
# -clike and -notlike are case sensitive versions
# 
# -match and -notmatch (along with case sensitive version -cmatch and -cnotmatch) make comparisons of string text and regular expressions patterns
# 
# 
# 
################################### 11.4: filtering objects out of the pipeline
# 
# these comparisons are usually used with the -filter parameter
# mostly the the Get-* cmdlets and and AD modules and of course the where-object cmdlet, which something of a generic filtering function for the shell
# 
# example:
Get-Service | Where-Object -filter { $_.Status -eq 'Running' }
# 
# Since the -filter parameter is positional, this is equivalent to above:
# 
Get-Service | Where { $_.Status -eq 'Running' }
# 
# explanation:
# when objects are piped to where-object, each object is is examined by where-object using its filter
# one object at a time is placed into the $_ placehodler and then runs the comparison to test for true/false
# 
# when false is found the object is dropped from the pipeline
# 
# if true is found the boject is piped out of the where-boject to the next cmdlet in the pipeline (the invisible out-default/formatting etc)
# 
# further explanation of the $_ placeholder...
# 
# $_ can only be used where PS is looking for it
# when the . is used, as in $_., this is telling PS to access or compare an object property not a whole object
# 
# more on get-member/gm...
# 
# this is where GM comes in, providing a quick and easy way to discover properties of an object which can then be used in comparisons
# 
# as has been mentioned before, column headers don't always reflect property names
# an example beeing in get-process: this will show "PM(MB)" as a column but 
# get-process | gm will show the actual property name of "PM"
# 
# 
# above and beyond: simplified syntax as of PS v3 versus older syntax
# 
# the simplied version is:
Get-Service | where Status -eq 'Running'
# 
# the older syntax, still needed for more comlpex comparisons, would be:
Get-Service | Where-Object {$_.Status -eq 'running' -AND $_.StartType -eq 'Manual' }
# 
# 
# 
# 
################################### 11.5: using iterative model (the second model from above)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
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
