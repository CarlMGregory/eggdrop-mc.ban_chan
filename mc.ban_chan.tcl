##
# Ban Channel v1.0.3 by MC_8 - Carl M. Gregory <gregory@worldinter.net>
#
# If you have any questions/comments/idea's, please email me!
# ( Include the script name and version in the title, if you do email me. )
#
# My SVS Website - http://mc.purehype.net/
##

##
# This script will ban people that are found in specified channels.
##

##
# Commands are preformed via DCC chat with the bot, here are a listing
# of the commands:
#
# This will show you a list of current ban'd channels.
#  .banchan [#channel]
# This will add a new channel ban.
#  .banchan [#channel] [add <#channel [reason]>]
# This will remove a channel ban.
#  .banchan [#channel] [remove <#channel>]
#
# If you specify [#channel] then the command is channel specific, otherwise
# is is global.
#
# <#channel> for the add/remove can contain wildcards, incase you want to
# ban certin words in channels names.  Ie. *pre*teen*  *sex*  or whatever.
##

##
# History
##
#  v1.0.3 (07.27.01)
#   MC_8 - Ahmad - Script would warn, wait x min's, then rescan... it wasn't
#                  doing the rescan, rather just performing the post punishment.
#   MC_8 - ReDDawG - Add what not functioning.
#   MC_8 - Updated SVS to v1.2
#   MC_8 - everyone - The script was accepting wildcards in the channel name to
#                     ban, but it had to have the #.  Now it doesn't.  The downside
#                     to this is, if you forget to put the channel to ban, it
#                     will assume the first word in the reason is the channel.
#
#  v1.0.2 (12.23.00)
#   MC_8 - Fixed SVS problem that made the bot crash upon startup or rehash/start
#
#  v1.0.1 (12.15.00)
#   MC_8 - Added SVS v1.0.1.
#   MC_8 - Eddie Briggs - Wasn't removing channels when commanded to.
#
#  v1.0 (11.15.00)
#   MC_8 - Inital release.
##

# What channels do you want this script to be active on?
# Seperate each channel with a space, set to "" for all channels.
set mc_banc(+chan) ""

# What channels do you want this script to not take part in?
# Seperate each channel with a space, set to "" for none.
set mc_banc(-chan) ""

# What flag'd users do you want the script to ignore?
set mc_banc(ig:flag) "mnb|mn"

# How long, after the user join's the channel, do you want to test to
# see if the user is still on the channel... and if so, scan him/her?
# This will prevent lagging the bot down with un nessassery join/parts
# real fast that so many lamers like to do.
# Set this in seconds.
set mc_banc(flytime) 10

# What do you want to call the datafile?
set mc_banc(datafile) "scripts/.badc.data"

# How often do you want to re scan the users?
# Yes, it scans each user on join, but this is to ensure they do not
# join a ban'd channel after they join your channel.
# Set this in minutes.  Set to 0 to turn off re`scanning.
set mc_banc(scan) 30

# If someone is found in a ban'd channel, what do you want the script to do?
# -2 = /MSG Warn
# -1 = Kick
#  0 = Server Ban
#  1 and up is ban time in min's.
set mc_banc(pre:pun) -2

# If the above setting is 0, How long do you want to give them before scanning
# them again for further punishment?  Set to 0 if you don't wanna rescan.
# (in min's)
set mc_banc(warn:time) 1

# What do you want to say for a warning/kick/ban message?
# %banchan will be replaced with the ban'd channel.
# %chan will be replaced with the current channel.
set mc_banc(warn:msg) "Hiya, you have 1 minute to leave %banchan or ya will be booted from %chan."

# If someone is STILL in the ban'd channel after giving them warning, what
# do you want the script to do?
# -1 = Kick
#  0 = Server Ban
#  1 and up is ban time in min's.
set mc_banc(post:pun) 5

# How do you want to mask the bans?
#      0 - *!user@host.domain
#      1 - *!*user@host.domain
#      2 - *!*@host.domain
#      3 - *!*user@*.domain
#      4 - *!*@*.domain
#      5 - nick!user@host.domain
#      6 - nick!*user@host.domain
#      7 - nick!*@host.domain
#      8 - nick!*user@*.domain
#      9 - nick!*@*.domain
#     You can also specify a type of 10 to 19 which correspond to masks 0 to 9, but
#     instead of using a * wildcard to replace portions of the host.domain, it uses ?
#     wildcards to replace the numbers in the address.
set mc_banc(banmask) 3


## MC SVS (Script Version Service) v1.2 ##
# Do you want the bot to connection to MC_8's SVS to see if there are newer versions
# of this script avilable?  It will only tell you -- It's up to you to get the newest
# version (I decided not to auto update the code, there may be new features in the
# newest script that may require your attention).
# 0=no/1=yes
set mc_banc(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_banc(svs:check) 0  ;#This is at Midnight
#  set mc_banc(svs:check) 5  ;#This is at 5am
#  set mc_banc(svs:check) 13  ;#This is at 1pm
#  set mc_banc(svs:check) 23  ;#This is at 11pm
set mc_banc(svs:check) 3

# Upon finding a newer version, who do you want to notify via note?
# Only the admin of the bot should really be worried about these notes,
# there the ones that keep everything up to par on the bots.
# Seperate each user with a " " (space).
set mc_banc(svs:notify) "MC_8"

# Do you want even beta version notified to whomever you have set?  Or just
# stable releases of the script?
#  0 = Tell me about all version, even beta versions.
#  1 = Just tell me about new stable versions.
set mc_banc(svs:stableonly) 0



### END OF CONFIG OPTIONS ###

set mc_banc(version) "v1.0.3"
set mc_banc(svs:script) "banchan 001000003000"
set mc_banc(svs:server) "mc.purehype.net 8085"

set mc_banc(+chan) [string tolower $mc_banc(+chan)]
set mc_banc(-chan) [string tolower $mc_banc(-chan)]

bind nick - * mc:bc:nick
proc mc:bc:nick {nick uhost hand chan newnick} {
 global mc_banc botnick
 if {$newnick != $botnick} {mc:banc:join $newnick $uhost $hand $chan}
}

bind join - * mc:banc:join
proc mc:banc:join {nick uhost hand chan} {
 global mc_banc botnick ; set chan [string tolower $chan]
 if {$mc_banc(+chan) == ""} {set chanz [string tolower [channels]]} {set chanz $mc_banc(+chan)}
 if {![string match "* $chan *" " $chanz "] ||
     [string match "* $chan *" " $mc_banc(-chan) "]} {return 0}
 set i 0
 foreach ban $mc_banc(!banchan) {
  if {([string tolower [lindex [join $ban] 0]] == [string tolower $chan]) ||
      ([string tolower [lindex [join $ban] 0]] == "global")} {set i 1;break}
 } ; if {!$i} {return 0}
 if {$nick == $botnick} {
  if {$uhost == "@"} {
   set i 0
   foreach user [chanlist $chan] {
    if {$user != $botnick} {
     incr i 1
     mc:banc:join $user [getchanhost $user $chan] [nick2hand $user $chan] $chan
     catch {unset mc_banc(join:$chan:i)}
    }
   }
   if {(!$i) && ($mc_banc(join:$chan:i) < "3")} {
    incr mc_banc(join:$chan:i) 1
    utimer 10 "mc:banc:join $botnick @ mc_banc(join:[split $chan]:i) [split $chan]"
   } {catch {unset mc_banc(join:$chan:i)}}; return 0
  } {
   set mc_banc(join:$chan:i) 1
   utimer 10 "mc:banc:join $botnick @ mc_banc(join:[split $chan]:i) [split $chan]"
   return 0
  }
 }
 if {[matchattr $hand $mc_banc(ig:flag) $chan]} {return 0}
 if {(!$mc_banc(flytime)) && (![string match "*mc:banc:join:scan $nick $chan*" [utimers]])} {
  mc:banc:join:scan [split $nick] [split $chan]
 } {
  utimer $mc_banc(flytime) "mc:banc:join:scan [split $nick] [split $chan]"
 }
}

proc mc:banc:join:scan {nick chan} {
 global mc_banc
 if {[onchan $nick $chan] && ![info exists mc_banc(!scan:$nick)]} {
  set mc_banc(!scan:$nick) 1
  puthelp "WHOIS $nick"
 }
 if {$mc_banc(scan) && [onchan $nick $chan]} {
  timer $mc_banc(scan) "mc:banc:join:scan [split $nick] [split $chan]"
 }
 if {(![string match "*unset mc_banc(!scan:[split $nick])*" [utimers]]) &&
     ([onchan $nick $chan])} {
  utimer 30 "catch {unset mc_banc(!scan:[mc:bc:inter:filt $nick])}"
 }
}

bind raw - 319 mc:banc:raw319
proc mc:banc:raw319 {from key args} {
 global mc_banc
 set args [join $args]
 set nick [lindex [split $args] 1]
 set chan(x) ""
 foreach chan(y) [join [string trimleft [lrange [split $args] 2 e] :]] {
  set chan(x) "$chan(x) [string trimleft $chan(y) -+@]"
 } ; set chan(euon) [string tolower [join $chan(x)]]
 if {$mc_banc(+chan) == ""} {set chan(active) [string tolower [channels]]} {
  set chan(active) $mc_banc(+chan)
 }
 set maskban [mc:bc:inter:masktype $nick![getchanhost $nick] $mc_banc(banmask)]
 foreach ban $mc_banc(!banchan) {
  if {![string match "* [lindex $ban 1] *" " $chan(euon) "]} {continue}
  if {[lindex $ban 0] == "global"} {
   foreach activechan $chan(active) {
    if {![onchan $nick $activechan]} {continue}
    if {![info exists mc_banc(!post:$nick:$activechan:[lindex $ban 1])]} {
     switch -- $mc_banc(pre:pun) {
      -2 {
       puthelp "PRIVMSG $nick :[mc:bc:inter:replace $mc_banc(warn:msg) "%banchan [lindex $ban 1] %chan $activechan"]"
       putlog "$nick was warned for being in [lindex $ban 1] while in $activechan."
       if {$mc_banc(warn:time)} {
        utimer [expr $mc_banc(warn:time)*60] "putserv {WHOIS [split $nick]}"
#        utimer [expr $mc_banc(warn:time)*60] "mc:banc:raw319 mc8.dynip.com 319 {x [split $nick] :[split $chan(euon)]}"
        set mc_banc(!post:$nick:$activechan:[lindex $ban 1]) 1
        utimer [expr ($mc_banc(warn:time)*60)+10] "catch {unset mc_banc(!post:[mc:bc:inter:filt $nick]:[mc:bc:inter:filt $activechan]:[mc:bc:inter:filt [lindex $ban 1]])}"
       }
      }
      -1 {
       puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
       putlog "$nick was kicked from $activechan for being in [lindex $ban 1]."
      }
      default {
       puthelp "MODE $activechan +b $maskban"
       puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
       if {$mc_banc(pre:pun)} {
        newchanban $activechan $maskban banchan [mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"] $mc_banc(pre:pun)
        putlog "$nick was baned from $activechan for $mc_banc(pre:pun) min's for being in [lindex $ban 1]."
       } {putlog "$nick was baned from $activechan for being in [lindex $ban 1]."}
      }
     }
    } {
     unset mc_banc(!post:$nick:$activechan:[lindex $ban 1])
     switch -- $mc_banc(post:pun) {
      -1 {
       puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
       putlog "$nick was kicked from $activechan for being in [lindex $ban 1]."
      }
      default {
       puthelp "MODE $activechan +b $maskban"
       puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
       if {$mc_banc(post:pun)} {
        newchanban $activechan $maskban banchan [mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"] $mc_banc(post:pun)
        putlog "$nick was baned from $activechan for $mc_banc(post:pun) min's for being in [lindex $ban 1]."
       } {putlog "$nick was baned from $activechan for being in [lindex $ban 1]."}
      }
     }
    }
   }
  } {
   set activechan [lindex $ban 0]
   if {![onchan $nick $activechan]} {continue}
   if {![info exists mc_banc(!post:$nick:$activechan:[lindex $ban 1])]} {
    switch -- $mc_banc(pre:pun) {
     -2 {
      puthelp "PRIVMSG $nick :[mc:bc:inter:replace $mc_banc(warn:msg) "%banchan [lindex $ban 1] %chan $activechan"]"
      putlog "$nick was warned for being in [lindex $ban 1] while in $activechan."
      if {$mc_banc(warn:time)} {
       utimer [expr $mc_banc(warn:time)*60] "mc:banc:raw319 mc8.dynip.com 319 {x [split $nick] :[split $chan(euon)]}"
       set mc_banc(!post:$nick:$activechan:[lindex $ban 1]) 1
        utimer [expr ($mc_banc(warn:time)*60)+10] "catch {unset mc_banc(!post:[mc:bc:inter:filt $nick]:[mc:bc:inter:filt $activechan]:[mc:bc:inter:filt [lindex $ban 1]])}"
      }
     }
     -1 {
      puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
      putlog "$nick was kicked from $activechan for being in [lindex $ban 1]."
     }
     default {
      puthelp "MODE $activechan +b $maskban"
      puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
      if {$mc_banc(pre:pun)} {
       newchanban $activechan $maskban banchan [mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"] $mc_banc(pre:pun)
       putlog "$nick was baned from $activechan for $mc_banc(pre:pun) min's for being in [lindex $ban 1]."
      } {putlog "$nick was baned from $activechan for being in [lindex $ban 1]."}
     }
    }
   } {
    unset mc_banc(!post:$nick:$activechan:[lindex $ban 1])
    switch -- $mc_banc(post:pun) {
     -1 {
      puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
      putlog "$nick was kicked from $activechan for being in [lindex $ban 1]."
     }
     default {
      puthelp "MODE $activechan +b $maskban"
      puthelp "KICK $activechan $nick :[mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"]"
      if {$mc_banc(post:pun)} {
       newchanban $activechan $maskban banchan [mc:bc:inter:replace [lrange $ban 2 e] "%banchan [lindex $ban 1] %chan $activechan"] $mc_banc(post:pun)
       putlog "$nick was baned from $activechan for $mc_banc(post:pun) min's for being in [lindex $ban 1]."
      } {putlog "$nick was baned from $activechan for being in [lindex $ban 1]."}
     }
    }
   }
  }
 } ; return 0
}

bind dcc - banchan mc:bc:dcc:banchan
proc mc:bc:dcc:banchan {hand idx args} {
 global mc_banc botnick ; set args [join $args]
 set chan [string tolower [lindex $args 0]]
 if {([lindex $args 1] == "") &&
     (($chan == "") || ([string index $chan 0] == "#"))} {
  if {$chan == ""} {
   putdcc $idx "Current ban'd channel list:"
   foreach ban $mc_banc(!banchan) {putdcc $idx " [join $ban]"} 
  } {
   putdcc $idx "Current ban'd channel list for $chan:"
   foreach ban $mc_banc(!banchan) {
    if {[lindex $ban 0] == $chan} {putdcc $idx " [join $ban]"}
   }
  }
 } {
  if {[string index $chan 0] != "#"} {
   if {![matchattr $hand m]} {
    putdcc $idx "You must be a global master to preform a global channel ban."
    return 0
   }
   set chan global
   set ar [string tolower [lindex $args 0]]
   set archan [string tolower [lindex $args 1]]
   set reason [lrange $args 2 e]
  } {
   if {![matchattr $hand m|m $chan]} {
    putdcc $idx "You must be a master on $chan to preform a channel ban."
    return 0
   }
   set ar [string tolower [lindex $args 1]]
   set archan [string tolower [lindex $args 2]]
   set reason [lrange $args 3 e]
  }
  if {$mc_banc(+chan) == ""} {set chanz [string tolower [channels]]} {set chanz $mc_banc(+chan)}
  if {($chan != "global") &&
      ((![string match "* $chan *" " $chanz "]) ||
      ([string match "* $chan *" " $mc_banc(-chan) "]))} {
   putdcc $idx "$chan isn't supported." ; return 0
  }
  if {($ar != "add") && ($ar != "remove")} {
   putdcc $idx "Invalid command $ar, valid options:  add, remove."
   return 0
  }
  if {$archan == ""} {
   putdcc $idx "Invalid syntax, must be:  banchan \[#channel\] \[add <#channel \[reason\]>/remove <#channel>\]"
   return 0
  }
  if {$ar == "add"} {
   foreach ban $mc_banc(!banchan) {
    if {$chan == "global"} {
     if {([lindex $ban 0] == "global") && ([lindex $ban 1] == $archan)} {
      putdcc $idx "$archan is already setup for a global ban."
      return 0
     }
    } {
     if {(([lindex $ban 0] == $chan) && ([lindex $ban 1] == $archan)) ||
         (([lindex $ban 0] == "global") && ([lindex $ban 1] == $archan))} {
      putdcc $idx "$archan is already setup for a ban."
      return 0
     }
    }
   }
   append mc_banc(!banchan) " \{[split $chan] [split $archan] [split $reason]\}"
   set i 0
   foreach ban $mc_banc(!banchan) {
    if {([string tolower [lindex [join $ban] 0]] == [string tolower $chan]) ||
        ([string tolower [lindex [join $ban] 0]] == "global")} {set i 1;break}
   } ; if {!$i} {mc:banc:join $botnick {} {} $chan}
  } {
   set i 1 ; set list ""
   foreach ban $mc_banc(!banchan) {
    if {([lindex $ban 0] == $chan) && ([lindex $ban 1] == $archan)} {set i 0} {
     set list "$list \{$ban\}" 
    }
   }
   if {$i} {
    putdcc $idx "$archan isn't a ban'd channel for $chan."
    return 0
   } {
    set mc_banc(!banchan) [string trimleft $list " "]
    putdcc $idx "Removed $archan from the ban list."
   }
  } ; mc:bc:save
 } ; return 1
}

proc mc:bc:save {} {
 global mc_banc
 set io [open $mc_banc(datafile) w]
 foreach ban $mc_banc(!banchan) {
  set ban [split $ban]
  puts $io "[lindex $ban 0] [lindex $ban 1] {[lrange $ban 2 e]}"
 };close $io;putlog "Writing banchan file..."
}

proc mc:bc:inter:masktype {uhost type} {
 if {![string match "*!*@*.*" $uhost]} {
  set nick [lindex [split $uhost "!"] 0]
  if {$nick == ""} {
   set uhost [string range $uhost [expr [string first ! $uhost]+1] e]
   foreach chan [channels] {
    set nick [lindex [findchanuser *$uhost* $chan] 0]
    if {$nick != ""} {break}
   }
   if {$nick == ""} {set uhost $nick!} {set uhost "$nick![mc:bc:inter:gethost $nick]"}
  }
  if {$uhost == "$nick!" || $nothing} {set type "return_nothing"}
 }
 switch -exact $type {
  0 {set ban "*[string range $uhost [string first ! $uhost] e]"}
  1 {set ban "*!*[string trimleft [string range $uhost [expr [string first ! $uhost]+1] e] "~"]"}
  2 {set ban "*!*[string range $uhost [string first @ $uhost] e]"}
  3 {
   set ident [string range $uhost [expr [string first ! $uhost]+1] [expr [string last @ $uhost]-1]]
   set ban "*!*[string trimleft $ident "~"][string range [maskhost $uhost] [string first @ [maskhost $uhost]] e]"
  }
  4 {set ban "*!*[string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"}
  5 {set ban $uhost}
  6 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
   set ban "$nick!*[string trimleft $ident "~"][string range $uhost [string last "@" $uhost] e]"
  }
  7 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ban "$nick!*[string range $uhost [string last "@" $uhost] e]"
  }
  8 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
   set ban "$nick!*[string trimleft $ident "~"][string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"
  }
  9 {
   set nick [string range $uhost 0 [expr [string first "!" $uhost]-1]]
   set ban "$nick!*[string range [maskhost $uhost] [string last "@" [maskhost $uhost]] e]"
  }
  10 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {
    set host [replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
    set ban "*!$ident$host"
   } {set ban [masktype $uhost 0]}
  }
  11 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {
    set host [replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ident [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]]
    set ban "*!*[string trimleft $ident "~"]$host"
   } {set ban [masktype $uhost 1]}
  }
  12 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {
    set host [replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set ban "*!*$host"
   } {set ban [masktype $uhost 2]}
  }
  13 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {set ban [masktype $uhost 11]} {set ban [masktype $uhost 3]}
  }
  14 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {set ban [masktype $uhost 12]} {set ban [masktype $uhost 4]}
  }
  15 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {
    set host [replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest [string range $uhost 0 [expr [string last "@" $uhost]-1]]
    set ban $rest$host
   } {set ban [masktype $uhost 5]}
  }
  16 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {
    set host [replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest "[string range $uhost 0 [expr [string first "!" $uhost]-1]]!*[string trimleft [string range $uhost [expr [string first "!" $uhost]+1] [expr [string last "@" $uhost]-1]] "~"]"
    set ban $rest$host
   } {set ban [masktype $uhost 6]}
  }
  17 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {
    set host [replace $host "1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? 0 ?"]
    set rest "[string range $uhost 0 [expr [string first "!" $uhost]-1]]!*"
    set ban $rest$host 
   } {set ban [masktype $uhost 7]}
  }
  18 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {set ban [masktype $uhost 16]} {set ban [masktype $uhost 8]}
  }
  19 {
   set host [string range $uhost [string last "@" $uhost] e]
   if {[findip [string range $host 1 e]] == "0"} {set ban [masktype $uhost 17]} {set ban [masktype $uhost 9]}
  }
  return_nothing {set ban ""}
  default {set ban "*!*[string range $uhost [string first "@" $uhost] e]"}
 }
 set _nick [lindex [split $ban !] 0]
 set _ident [string range $ban [expr [string first ! $ban]+1] [expr [string last @ $ban]-1]]
 set _host [string range $ban [expr [string last @ $ban]+1] e]
 if {$_ident != [set temp [string range $_ident [expr [string length $_ident]-9] e]]} {
  set _ident *[string trimleft $temp *]
 }
 if {$_host != [set temp [string range $_host [expr [string length $_host]-63] e]]} {
  set _host *[string trimleft $temp *]
 } ; return $_nick!$_ident@$_host
}

proc mc:bc:inter:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 } ; return $string
}

proc mc:bc:inter:gethost {args} {
 set nik [lindex [split $args] 0]
 foreach chan [channels] {
  if {[onchan $nik $chan]} {
   return [getchanhost $nik $chan]
  }
 } ; return ""
}

proc mc:bc:inter:filt {data} {
 regsub -all -- \\\\ $data \\\\\\\\ data ; regsub -all -- \\\[ $data \\\\\[ data ; regsub -all -- \\\] $data \\\\\] data
 regsub -all -- \\\} $data \\\\\} data ; regsub -all -- \\\{ $data \\\\\{ data ; regsub -all -- \\\" $data \\\\\" data ; return $data
}

set mc_banc(!banchan) ""
if {![file exists $mc_banc(datafile)]} {
 set io [open $mc_banc(datafile) w] ; close $io
 set temp "Datafile not detected, remember to add ban'd channels.\n `-Commands are explained in the script."
} {
 set io [open $mc_banc(datafile) r]
 while {![eof $io]} {
  set string [gets $io]
  if {[join $string] == ""} {continue}
  set mc_banc(!banchan) "$mc_banc(!banchan) \{[split [lindex $string 0]] [split [lindex $string 1]] [split [lindex $string 2]]\}"
 } ; close $io
 set mc_banc(!banchan) [string trimleft $mc_banc(!banchan) " "]
 set mc_banc(!banchan) [string trimright $mc_banc(!banchan) " "]
 set temp ""
}

## SVS v1.2
if {![info exists mc_banc(svs:enabled)]} {set mc_banc(svs:enabled) 0}
if {($mc_banc(svs:enabled) != "0") && ($mc_banc(svs:enabled) != "1")} {set mc_banc(svs:enabled) 0}
if {![info exists mc_banc(svs:check)]} {set mc_banc(svs:check) 0}
if {([catch {expr $mc_banc(svs:check)+1}]) || (!$mc_banc(svs:check))} {
 set mc_banc(svs:check) 0
}
if {![info exists mc_banc(svs:notify)]} {set mc_banc(svs:notify) $owner}
if {![info exists mc_banc(svs:stableonly)]} {set mc_banc(svs:stableonly) 0}
if {($mc_banc(svs:stableonly) != "0") && ($mc_banc(svs:stableonly) != "1")} {
 set mc_banc(svs:stableonly) 0
}
if {$mc_banc(svs:enabled)} {
 if {($mc_banc(svs:check) > "23") || ($mc_banc(svs:check) < "0")} {set mc_banc(svs:check) 00}
 if {[string length $mc_banc(svs:check)] == "1"} {set mc_banc(svs:check) 0$mc_banc(svs:check)}
 if {$mc_banc(svs:stableonly)} {
  set mc_banc(svs:script) [string range $mc_banc(svs:script) 0 [expr [string length $mc_banc(svs:script)]-4]]999
 }
 catch {unbind time - "00 $mc_banc(svs:oldcheck) * * *" mc:banc:svs:time}
 set mc_banc(svs:oldcheck) $mc_banc(svs:check)
 bind time - "00 $mc_banc(svs:check) * * *" mc:banc:svs:time
 proc mc:banc:svs:time {min hour day month year} {
  global replaceme.
  catch {control [connect [lindex $mc_banc(svs:server) 0] [lindex $mc_banc(svs:server) 1]] mc:banc:svs:interface}
 }
}
proc mc:banc:svs:interface {idx args} {
 global replaceme.;set args [join $args]
 switch -- [lindex $args 0] {
  "" {return 1}
  000 {putdcc $idx q}
  002 {putdcc $idx [lindex $mc_banc(svs:script) 0]}
  003 {
   set args [lrange $args 1 e]
   if {[lindex $args 0] != [lindex $mc_banc(svs:script) 0]} {return 0}
   putdcc $idx q
   if {[lindex $args 1] > [lindex $mc_banc(svs:script) 1]} {
    set note [mc:banc:svs:replace [lindex $args 7] "%0 {[lindex $args 0]} %1 {[lindex $args 1]} %2 {[lindex $args 2]}"]
    set note [mc:banc:svs:replace $note "%3 {[lindex $args 3]} %4 {[lindex $args 4]} %5 {[lindex $args 5]}"]
    set note [mc:banc:svs:replace $note "%6 {[lindex $args 6]} %8 {[lindex $args 8]} %version {$mc_banc(version)}"]
    set note [mc:banc:svs:replace $note "%9 {[lindex $args 9]} %10 {[lindex $args 10]} %11 {[lindex $args 11]}"]
    set note [mc:banc:svs:replace $note "%12 {[lindex $args 12]} %13 {[lindex $args 13]} %14 {[lindex $args 14]}"]
    set note [mc:banc:svs:replace $note "%15 {[lindex $args 15]} %16 {[lindex $args 16]} %17 {[lindex $args 17]}"]
    set note [mc:banc:svs:replace $note "%18 {[lindex $args 18]} %19 {[lindex $args 19]} %20 {[lindex $args 20]}"]
    foreach notify [join [split $mc_banc(svs:notify) ",;"]] {
     set outnote [mc:banc:svs:replace $note "%nick {$notify}"]
     if {[string match "*$outnote*" "[notes $notify -[notes $notify]]"]} {
      set cont 0
      foreach unote [notes $notify -[notes $notify]] {
       if {$outnote == [lindex $unote 2]} {set cont 1;break}
      };if {$cont} {continue}
     }
     switch -- [sendnote SVS $notify $outnote] {
      0 {putlog "MC SVS for [lindex $mc_banc(svs:script) 0] had some errors updating $notify on current version of script; unknown reason!"}
      3 {putlog "MC SVS for [lindex $mc_banc(svs:script) 0] had some errors updating $notify on current version of script; notebox too full!"}
     }
    }
   }
  }
 };return 0
}
## ^

if {[info exists mc_banc()]} {
 putlog " ,- mc_banc() detected -- you cannot change the words in the ()'s!"
 putlog " |- This script may not function correctly..."
 putlog " V"
}
putlog "Ban Channel $mc_banc(version) by MC_8 loaded. $temp"