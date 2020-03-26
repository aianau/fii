# General conduct

## Mentality behind development 

* when adding a feature / develop something, imagine that sometime it may
be subject to change. So bear in mind to ask yourself: "If I want to 
add / delete / change something, in how many places should I edit 
to make things work?" The response to this MUST always be "1 place"
* TOKENS are written with capital letters
* trying to stick as much as we can to the c++ style
* non-terminals are written with small leters
* tabs are 4 spaces in length
* each two grammar rules that define 2 different non-terminals have a \n between
* each problem is reported by using issues.

## Yacc specific development
* any ':' or '|' should be one indent way from the non-terminal and then 
continued by one space and the rule.
example: "non_terminal  : rule"
