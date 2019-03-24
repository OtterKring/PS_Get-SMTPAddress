<center><a href="https://otterkring.github.io/MainPage" style="font-size:75%;">return to MainPage</a></center>

# PS_Get-SMTPAddress
## List mail addresses of a mail enabled object in Exchange Online or on-premise


### Why ...

When managing Exchange on-prem or online you will check for the PrimarySMTPAddress of a mailbox (or other mail enabled object) quite often. And for other mail aliases, too.

I somewhen got tired of typing ...

    Get-Mailbox mcfly | fl PrimarySMTPAddress

...for the main address, or...

    Get-Mailbox mcfly | fl emailaddresses

...and then having to deal with all kinds of addresses, smtp or other. Sure, you can then filter out the non-smtp addresses like ...

    Get-Mailbox mcfy | select -expandproperty emailaddresses | ?{$_.PrefixString -eq 'smtp'}

... but - hey! - this is a lot to write for a quick check and ONLY works on-prem when working directly in the Exchange Management Console.

If you are working with an imported exchange session or Exchange Online, you must filter like:

    Get-Mailbox mcfly | select emailaddresses | ?{$_ -like 'SMTP:*'}

And, of course, you need to know, which type of object you need to check: mailbox, remotemailbox, mailuser, mailcontact, distribution group or dynamic distribution group. *Except* you use `Get-Recipients` from the start, but that still requires the filtering.


Enter...

### Get-SMTPAddress [-PrimaryOnly]

To make mail address checking simple I condensed the above in a short function to save myself time during the day.

No matter if you are using Exchange Management Console, Exchange Online or an imported session, just add my function to your profile and type ...

    Get-SMTPAddress mcfly

To get a sorted list of all smtp address of the requested object, let by the PrimarySMTPAddress. The latter can singled out by using the switch `-PrimaryOnly`.

Pipeline is supported, of course.



I hope this will save you a couple of seconds each day, too.

Happy coding!<br>
Max.