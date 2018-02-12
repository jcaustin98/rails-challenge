#Caveats
Please be aware that in my phone screen, I said I had never done Ruby on Rails.
Because of the learning curve, I did not get to refine and cleanup the code.

There are a couple of problems that I did not get to fix due to time:
 index/listing page - no friend count
 view page - the friend drop down works, but shows duplicate names
 
I also did not get to do any automated testing. Just ran out of time to learn and complete.

I am very sure with more learning time, I could cleanup the code and write the automated tests.

I did a lot of functional testing and documented some of it below.

#Functional testing setup
Added: 
name George Washington
url https://en.wikipedia.org/wiki/George_Washington
Some of the topics
```
 Cherry tree
 French and Indian War
 Between the wars: Mount Vernon (1759–1774)
 Beginnings of War
```

name John Sullivan 
url https://en.wikipedia.org/wiki/John_Sullivan_(general)
Some of the topics:
 Revolutionary War
 
name James Clinton
url https://en.wikipedia.org/wiki/James_Clinton
Some of the topics:
 French and Indian War
 American Revolutionary War
 After War Years
Friendships
 George Washington
 John Sullivan 
 
name Charles Clinton
https://en.wikipedia.org/wiki/Charles_Clinton
Indian War
friendships
 James Clinton

#Functional testing
Select Charles Clinton
search for War
 Charles Clinton -> James Clinton -> John Sullivan  (Revolutionary War)
 Charles Clinton -> James Clinton -> George Washington (French and Indian War
 Charles Clinton -> James Clinton -> George Washington (Beginnings of War)
 
Select Charles Clinton
search for Cherry
 Charles Clinton -> James Clinton -> George Washington (Cherry Tree)