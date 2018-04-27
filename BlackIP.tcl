#######################################################################################################
## BlackIP.tcl 1.8 			                  Copyright 2008 - 2018 @ WwW.TCLScripts.NET ##
##                        _   _   _   _   _   _   _   _   _   _   _   _   _   _                      ##
##                       / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \                     ##
##                      ( T | C | L | S | C | R | I | P | T | S | . | N | E | T )                    ##
##                       \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/                     ##
##                                                                                                   ##
##                                      ® BLaCkShaDoW Production ®                                   ##
##                                                                                                   ##
##                                              PRESENTS                                             ##
##									                           ® ##
###########################################   BLACK IP TCL   ##########################################
##									                             ##
##  DESCRIPTION: 							                             ##
##  Returns IP address dns, location and organization informations for a nick/IP/hostname.           ##
##									                             ##
##  Both IPv4 & IPv6 supported.                                                                      ##                                                                    ##
##									                             ##
##  Tested on Eggdrop v1.8.3 (Debian Linux 3.16.0-4-amd64) Tcl version: 8.6.6                        ##
##									                             ##
#######################################################################################################
##									                             ##
##  INSTALLATION: 							                             ##
##     ++ http & tls packages are REQUIRED for this script to work.                                  ##
##     ++ Edit the BlackIP.tcl script and place it into your /scripts directory,                     ##
##     ++ add "source scripts/BlackIP.tcl" to your eggdrop config and rehash the bot.                ##
##									                             ##
#######################################################################################################
##									                             ##
##  CHANGELOG:                                                                                       ##
##  - 1.8 version                                                                                    ##
##    + added a flood protection settings against those who abuse the use of command.                ##
##    + added extra stuff for suspicious details as: proxy, tor and spam.                            ##
##    + added extra stuff fo latitude/longitude, mobile and timezone date details.                   ##
##    + added utf-8 support.                                                                         ##
##    + minor bugs fixed.                                                                            ##
##  - 1.7 version                                                                                    ##
##    + completely rebuilt in a new style and with another source for IP informations.               ##
##    + now supports IPv6.                                                                           ##
##    + supports eggdrop version less than 1.8.*                                                     ##
##    + added multi-languages for every channel: RO, EN, FR, ES & IT.                                ##
##    + minor bugs fixed.                                                                            ##
##									                             ##
#######################################################################################################
##									                             ##
##  OFFICIAL LINKS:                                                                                  ##
##   E-mail      : BLaCkShaDoW[at]tclscripts.net                                                     ##
##   Bugs report : http://www.tclscripts.net                                                         ##
##   GitHub page : https://github.com/tclscripts/ 			                             ##
##   Online help : irc://irc.undernet.org/tcl-help                                                   ##
##                 #TCL-HELP / UnderNet        	                                                     ##
##                 You can ask in english or romanian                                                ##
##									                             ##
##          Please consider a donation. Thanks!                                                      ##
##									                             ##
#######################################################################################################
##									                             ##
##                           You want a customised TCL Script for your eggdrop?                      ##
##                                Easy-peasy, just tell me what you need!                            ##
##                I can create almost anything in TCL based on your ideas and donations.             ##
##                  Email blackshadow@tclscripts.net or info@tclscripts.net with your                ##
##                    request informations and I'll contact you as soon as possible.                 ##
##									                             ##
#######################################################################################################
##									                             ##
##  To activate: .chanset +ip | from BlackTools: .set #channel +ip                                   ##
##                                                                                                   ##
##  !ip [nick|IP|host] - shows details assigned to that IP address or nick.                          ##
##                                                                                                   ##
##  !set iplang [RO|EN|FR|ES|IT] - set a language for output messages.                               ##
##                                                                                                   ##
##  !ip version - returns the BlackIP script version.                                                ##
##                                                                                                   ##
##  Supports: both IPv4 & IPv6.                                                                      ##
##                                                                                                   ##
#######################################################################################################
##                                                                                                   ##
##  EXAMPLES:                                                                                        ##
##									                             ##
## [request for IP]                                                                                  ##
##  <user> !ip 188.209.52.109                                                                        ##
##  <bot> 188.209.52.109 is located in Netherlands (52.3824, 4.8995) ; Timezone: Europe/Amsterdam    ##
##        Host: hosted-by.blazingfast.io ; ISP: BlazingFast LLC ; Mobile: false ; Proxy: false       ##
##        Spam: false ; TOR: false ; Suspicious: false                                               ##
##                                                                                                   ##
## [request for hostname]                                                                            ##
##  <user> !ip hosted-by.blazingfast.io                                                              ##
##  <bot> hosted-by.blazingfast.io is located in Amsterdam, Netherlands (52.3824, 4.8995)            ##
##        Timezone: Europe/Amsterdam ; IP: 188.209.52.109 ;  ; ISP: BlazingFast LLC ; Mobile: false  ##
##        Proxy: false ; Spam: false ; TOR: false ; Suspicious: false                                ##
##                                                                                                   ##
## [request for nick]                                                                                ##
##  <user> !ip TCLHelp                                                                               ##
##  <bot> Nickname: TCLHelp ; Host: tclscripts.net                                                   ##
##  <bot> tclscripts.net is located in Munich (Ramersdorf - Perlach), Germany (48.1044, 11.601)      ##
##        Timezone: Europe/Berlin ; IP: 5.189.157.89 ; ISP: Contabo GmbH ; Mobile: false             ##
##        Proxy: false ; Spam: false ; TOR: false ; Suspicious: false                                ##
##                                                                                                   ##
#######################################################################################################
##									                             ##
##  LICENSE:                                                                                         ##
##   This code comes with ABSOLUTELY NO WARRANTY.                                                    ##
##                                                                                                   ##
##   This program is free software; you can redistribute it and/or modify it under the terms of      ##
##   the GNU General Public License version 3 as published by the Free Software Foundation.          ##
##                                                                                                   ##
##   This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of          ##
##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                                            ##
##   USE AT YOUR OWN RISK.                                                                           ##
##                                                                                                   ##
##   See the GNU General Public License for more details.                                            ##
##        (http://www.gnu.org/copyleft/library.txt)                                                  ##
##                                                                                                   ##
##  			          Copyright 2008 - 2018 @ WwW.TCLScripts.NET                         ##
##                                                                                                   ##
#######################################################################################################

#######################################################################################################
###                                 CONFIGURATION FOR BlackIP.TCL                                   ###
#######################################################################################################

###
# Cmdchar trigger
# - set here the trigger you want to use.
###
set blackip(cmd_char) "!"

###
# set here who can execute the command (-|- for all)
###
set black(ip_flags) "-|-"

###
# Language setting
# - set here the default language of the script
# - supports different languages for every channel
#   ( RO / EN / IT / FR / ES )
###
set black(default_lang) "en"

###
# FLOOD PROTECTION
#Set the number of minute(s) to ignore flooders, 0 to disable flood protection
###
set black(ignore_prot) "1"

###
# FLOOD PROTECTION
#Set the number of requests within specifide number of seconds to trigger flood protection.
# By default, 4:10, which allows for upto 3 queries in 10 seconds. 4 or more quries in 10 seconds would cuase
# the forth and later queries to be ignored for the amount of time specifide above.
###
set black(flood_prot) "2:10"

#Use secure connection (https) for host info ? (0-no; 1-yes)
#If you want https, you have to install tls package
# https version (using tls package) have extra informations as: is_spam, , is_tor or is_suspicious
###
set black(ip_secured) "0"

#######################################################################################################
###                       DO NOT MODIFY HERE UNLESS YOU KNOW WHAT YOU'RE DOING                      ###
#######################################################################################################

package require http
package require json

###
# Channel flags
###
setudef flag ip
setudef str iplang

###
# Bindings
# - using commands
###
bind pub $black(ip_flags) $blackip(cmd_char)ip black:ip:check

###
if {$black(ip_secured) == "1"} {
package require tls
}

proc black:ip:check {nick host hand chan arg} {
	set ip [lindex [split $arg] 0]
if {![channel get $chan ip]} {
return
}

	set flood_protect [blackip:flood:prot $chan $host]
if {$flood_protect == "1"} {
	set get_seconds [blackip:get:flood_time $host $chan]
	blackip:tell $nick $chan 19 [list $get_seconds $nick]
	return
}

if {[string match -nocase $ip "version"]} {
	blackip:tell $nick $chan 20 [list $nick]
	return
}

if {$ip == ""} {
	blackip:tell $nick $chan 1 none
	return
}

if {![string match -nocase "*:*" $ip] && ![string match -nocase "*.*" $ip]} {
	putserv "USERHOST :$ip"
	set ::ipchan $chan
	set ::ip_search $ip
	bind RAW - 302 check:for:nick
	return
}
	set check_domain [blackip:domain $ip]
if {$check_domain != "0"} {
	check:ip $ip $chan 2 [list $check_domain $nick 1]
	return
	}
	set check_dns [blackip:getdns $ip]
if {$check_dns != "0"} {
	check:ip $ip $chan 2 [list $check_dns $nick 2]
	return
}
	check:ip $ip $chan 2 [list 0 $nick 3]
}

###
proc check:for:nick { from keyword arguments } {
	global black
	set ip $::ip_search
	set chan $::ipchan
	set hosts [lindex [split $arguments] 1]
	set hostname [lindex [split $hosts "="] 1]
	regsub {^[-+]} $hostname "" mask
	set nickname [lindex [split $hosts "="] 0]
	regsub {^:} $nickname "" nick
if {$nick == ""} {
	blackip:tell "" $chan 2 $ip
	unbind RAW - 302 check:for:nick
	return
}
	set mask [lindex [split $mask @] 1]
	set check_domain [blackip:domain $mask]
if {$check_domain != "0"} {
	check:ip $mask $chan 3 [list $check_domain $nick 1]
	unbind RAW - 302 check:for:nick
	return
	}
	set check_dns [blackip:getdns $mask]
if {$check_dns != "0"} {
	check:ip $mask $chan 3 [list $check_dns $nick 2]
	unbind RAW - 302 check:for:nick
	return
}
	check:ip $mask $chan 3 [list 0 $nick 3]
	unbind RAW - 302 check:for:nick
}

###
proc blackip:domain {ip} {
	global black
	set get_domain ""
	set check_ipv4 [regexp {^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$} $ip]
	set check_ipv6 [regexp {^([0-9A-Fa-f]{0,4}:){2,7}([0-9A-Fa-f]{1,4}$|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$} $ip]
if {$check_ipv4 == "1" || $check_ipv6 == "1"} {
	set gethost [catch {exec host $ip 2>/dev/null} results]
	regexp {(pointer) (.*)} $results get_domain
if {$get_domain != ""} {
	set domain [string trimright [lindex $get_domain 1] "."]
	return $domain
		} else { return 0 }
	} else { return 0 }
}

###
proc blackip:getdns {ip} {
	global black
	set ipv4 ""
	set ipv6 ""
	set gethost [catch {exec host $ip 2>/dev/null} results]
	set res [lrange [split $results] 0 end]
	set inc 0
	set llength [llength $res]
for {set i 0} { $i <= $llength} { incr i } {
	set word [lindex $res $i]
if {[string match -nocase "*IPv6*" $word]} {
	lappend ipv6 [join [lindex $res [expr $i + 2]]]
	}
if {[string match -nocase "*address*" $word] && ![string match -nocase "*IPv6*" [lindex $res [expr $i - 1]]]} {
	lappend ipv4 [join [lindex $res [expr $i + 1]]]
	}
}
if {$ipv4 == "" && $ipv6 == ""} {
	return 0
	}
	return [list $ipv4 $ipv6]
}

###
proc check:ip {ip chan status arg} {
global black
	set type [lindex $arg 2]
	set reverse_dns 0
	set is_secured 0
	set domain ""
	set ipv4_list ""
	set ipv6 ""
	set proxy ""
	set is_tor ""
	set is_spam ""
	set is_suspicious ""
	set ipv4 ""
	set ipv6_list ""
	set other_ips ""
	set ip_to_check ""
if {$type == "1"} {
	set domain [lindex $arg 0]
	set reverse_dns 1
	set proxy [blackip:proxy_check $ip]
} elseif {$type == "2"} {
	set reverse_dns 2
	set ips [lindex $arg 0]
	set ipv4_list [lindex $ips 0]
	set ipv6_list [lindex $ips 1]
if {$ipv6_list != ""} {
if {[llength $ipv6_list] > 1} { 
	set ipv6 [lindex $ipv6_list 0]
	set ipv6_list [lreplace $ipv6_list 0 0]
	} else { 
	set ipv6 $ipv6_list 
	set ipv6_list ""
	}
	} else {
if {[llength $ipv4_list] > 1} { 
	set ipv4 [lindex $ipv4_list 0]
	set ipv4_list [lreplace $ipv4_list 0 0]
} else { 
	set ipv4 $ipv4_list 
	set ipv4_list ""
		}
	}
}
	set ipv4_list [join $ipv4_list ", "]
	set ipv6_list [join $ipv6_list ", "]
if {$reverse_dns == "2"} {
if {$ipv6 != ""} {
	set ip_to_check $ipv6
	} elseif {$ipv4 != ""} {
	set ip_to_check $ipv4
	}
} else {
	set ip_to_check $ip
}

if {$ipv4_list != ""} {
	lappend other_ips $ipv4_list
}
if {$ipv6_list != ""} {
	lappend other_ips $ipv6_list
}
	set other_ips [join $other_ips ", "]
	set data [blackip:data $ip_to_check]
	set stat [blackip:json "status" $data]
if {$stat == "fail"} {
	blackip:tell "" $chan 16 $ip_to_check
	return
}
	set region_name [blackip:json "regionName" $data]
	set country [blackip:json "country" $data]
	set city [blackip:json "city" $data]
	set location [join [encoding convertfrom "utf-8" [list $city $region_name $country]] ", "]
	set lat [blackip:json "lat" $data]
	set lon [blackip:json "lon" $data]
	set latlon [join "$lat $lon" ", "]
	set timezone [blackip:json "timezone" $data]
	set mobile [blackip:getstatus [blackip:json "mobile" $data] $chan]
	set org [blackip:json "isp" [encoding convertfrom "utf-8" $data]]
if {$black(ip_secured) == "1"} {
	set is_secured 1
	set data_secured [blackip:data_secured $ip_to_check]
	set suspicious [blackip:json "suspicious_factors" $data_secured]
	set proxy [lindex $suspicious 1]
	set is_tor [blackip:getstatus [lindex $suspicious 3] $chan]
	set is_spam [blackip:getstatus [lindex $suspicious 5] $chan]
	set is_suspicious [blackip:getstatus [lindex $suspicious 7] $chan]
}
if {$ip_to_check != "" && $is_secured == "0"} {
	set proxy [blackip:proxy_check $ip_to_check]
if {$proxy != "0"} {
	set proxy "true"
	} else { set proxy "false" }
}
	set proxy [blackip:getstatus $proxy $chan]
if {$status == "3"} {
	set nickname [lindex $arg 1]
	blackip:tell "" $chan 9 [list $ip $nickname]
}
if {$reverse_dns == "1"} {
if {$is_secured == "1"} {
	blackip:tell "" $chan 13 [list $ip $location $latlon $timezone $domain $proxy $is_spam $is_tor $is_suspicious $org $mobile]
} else {	
	blackip:tell "" $chan 6 [list $ip $location $latlon $timezone $domain $org $proxy $mobile]
}
	return
} elseif {$reverse_dns == "2"} {
if {$is_secured == "1"} {
	blackip:tell "" $chan 12 [list $ip $location $latlon $timezone $ip_to_check $proxy $is_spam $is_tor $is_suspicious $org $mobile]
} else {
	blackip:tell "" $chan 5 [list $ip $location $latlon $timezone $ip_to_check $org $proxy $mobile]
}
	} else {
if {$is_secured == "1"} {
	blackip:tell "" $chan 15 [list $ip $location $latlon $timezone $proxy $is_spam $is_tor $is_suspicious $org $mobile]
} else {
	blackip:tell "" $chan 14 [list $ip $location $latlon $timezone $org $proxy $mobile]
	}
}
if {$other_ips != ""} {
	blackip:tell "" $chan 11 [list $other_ips]
	}
}

###
# Credits
###
set blackip(projectName) "BlackIP"
set blackip(author) "BLaCkShaDoW"
set blackip(website) "wWw.TCLScriptS.NeT"
set blackip(email) "BLaCkShaDoW@TCLScriptS.NeT"
set blackip(version) "v1.8 (IPv6 support)"

###
proc blackip:data_secured {ip} {
	global black
	set link "https://ip-api.io/json/$ip"
	http::register https 443 [list ::tls::socket -tls1 1]
	set ipq [http::config -useragent "lynx"]
	set ipq [::http::geturl $link] 
	set data [http::data $ipq]
	::http::cleanup $ipq
	return $data
}

###
proc blackip:data {ip} {
	global black
	set link "http://ip-api.com/json/$ip?fields=country,regionName,city,lat,lon,timezone,mobile,proxy,query,reverse,status,message,isp"
	set ipq [http::config -useragent "lynx"]
	set ipq [::http::geturl $link] 
	set data [http::data $ipq]
	::http::cleanup $ipq
	return $data
}

###
proc blackip:json {get data} {
	global black
	set parse [::json::json2dict $data]
	set return ""
foreach {name info} $parse {
if {[string equal -nocase $name $get]} {
	set return $info
	break;
		}
	}
	return $return
}

###
proc blackip:get_other {ip} {
	global black
	set link "http://ip-api.com/json/$ip?fields=country,regionName,city,lat,lon,timezone,mobile,proxy,query,reverse,status,message,isp"
	set ipq [http::config -useragent "lynx"]
	set ipq [::http::geturl $link] 
	set data [http::data $ipq]
	::http::cleanup $ipq
	set isp [blackip:json "isp" $data]
	set mobile [blackip:json "mobile" $data]
if {$isp != ""} { return [list $isp $mobile]} else { return 0 }
}

###
proc blackip:proxy_check {ip} {
	global black
	set type ""
	set link "http://proxycheck.io/v1/$ip"
	set ipq [http::config -useragent "lynx"]
	set ipq [::http::geturl $link] 
	set data [http::data $ipq]
	::http::cleanup $ipq
	set proxy [blackip:json "proxy" $data]
if {$proxy == "yes"} {
	return [list $proxy]
} else {
	return 0
	}
	return 0
}

###
proc blackip:tell {nick chan type arg} {
	global black
	set inc 0
foreach s $arg {
	set inc [expr $inc + 1]
	set replace(%msg.$inc%) $s
}
	set getlang [blackip:getlang $chan]
if {[info exists black(blackip.$getlang.$type)]} {
	set reply [string map [array get replace] $black(blackip.$getlang.$type)]
if {$nick != ""} {
	putserv "NOTICE $nick :$reply"
} else {
	putserv "PRIVMSG $chan :$reply"
		}
	}
}

###
proc blackip:getstatus {text chan} {
	global black
	set getlang [blackip:getlang $chan]
		switch $text {
	true {
	return $black(blackip.$getlang.17)
		}		
		
	false {
	return $black(blackip.$getlang.18)
		}	
	}
}

###
proc blackip:getlang {chan} {
	global black
	set getlang [string tolower [channel get $chan iplang]]
if {$getlang == ""} {
	set lang [string tolower $black(default_lang)]
} else {
if {[info exists black(blackip.$getlang.1)]} {
	set lang $getlang
} else { 
	set lang [string tolower $black(default_lang)]
		}
	}
	return $lang
}

###

proc blackip:flood:prot {chan host} {
	global black
	set number [scan $black(flood_prot) %\[^:\]]
	set timer [scan $black(flood_prot) %*\[^:\]:%s]
if {[info exists black(ipflood:$host:$chan:act)]} {
	return 1
}
foreach tmr [utimers] {
if {[string match "*blackip:remove:flood $host $chan*" [join [lindex $tmr 1]]]} {
	killutimer [lindex $tmr 2]
	}
}
if {![info exists black(ipflood:$host:$chan)]} { 
	set black(ipflood:$host:$chan) 0 
}
	incr black(ipflood:$host:$chan)
	utimer $timer [list blackip:remove:flood $host $chan]	
if {$black(ipflood:$host:$chan) > $number} {
	set black(ipflood:$host:$chan:act) 1
	utimer [expr $black(ignore_prot) * 60] [list blackip:expire:flood $host $chan]
	return 1
	} else {
	return 0
	}
}

###
proc blackip:remove:flood {host chan} {
	global black
if {[info exists black(ipflood:$host:$chan)]} {
	unset black(ipflood:$host:$chan)
	}
}

###
proc blackip:expire:flood {host chan} {
	global black
if {[info exists black(ipflood:$host:$chan:act)]} {
	unset black(ipflood:$host:$chan:act)
	}
}

###
proc blackip:get:flood_time {host chan} {
	global black
		foreach tmr [utimers] {
if {[string match "*blackip:expire:flood $host $chan*" [join [lindex $tmr 1]]]} {
	return [lindex $tmr 0]
		}
	}
}

#Languages
# Romanian
###
set black(blackip.ro.1) "\[BlackIP\] Foloseste: \002!ip\002 \[ip|\002host\002|nickname\]"
set black(blackip.ro.2) "\[\002%msg.1%\002\] nu este online."
set black(blackip.ro.3) "\[\002X\002\] nu am putut rezolva adresa \002%msg.1%\002."
set black(blackip.ro.4) "\[\002X\002\] nu am putut rezolva adresa \002%msg.1%\002 apartinand lui \002%msg.2%\002."
set black(blackip.ro.5) "\002%msg.1%\002 e localizat in \002%msg.2%\002 (%msg.3%) ; \002Fus orar\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Mobil\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.ro.6) "\002%msg.1%\002 e localizat in \002%msg.2%\002 (%msg.3%) ; \002Fus orar\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Mobil\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.ro.9) "\002Nick\002: %msg.2% ; \002Host\002: %msg.1%"
set black(blackip.ro.11) "\002Alte rDNS\002: %msg.1%"
set black(blackip.ro.12) "\002%msg.1%\002 e localizat in \002%msg.2%\002 (%msg.3%) ; \002Fus orar\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Mobil\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Suspect\002: %msg.9%"
set black(blackip.ro.13) "\002%msg.1%\002 e localizat in \002%msg.2%\002 (%msg.3%) ; \002Fus orar\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Mobil\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Suspect\002: %msg.9%"
set black(blackip.ro.14) "\002%msg.1%\002 e localizat in \002%msg.2%\002 (%msg.3%) ; \002Fus orar\002: %msg.4% ; \002ISP\002: %msg.5% ; \002Mobil\002: %msg.7% ; \002Proxy\002: %msg.6%"
set black(blackip.ro.15) "\002%msg.1%\002 e localizat in \002%msg.2%\002 (%msg.3%) ; \002Fus orar\002: %msg.4% ; \002ISP\002: %msg.9% ; \002Mobil\002: %msg.10% ; \002Proxy\002: %msg.5% ; \002Spam\002: %msg.6% ; \002TOR\002: %msg.7% ; \002Suspect\002: %msg.8%"
set black(blackip.ro.16) "\[X\] \002%msg.1%\002 adresa IP necunoscuta"
set black(blackip.ro.17) "da"
set black(blackip.ro.18) "nu"
set black(blackip.ro.19) "\002%msg.2%\002: Trimiti cereri prea repede. Calmeaza-te si incearca din nou dupa \002%msg.1% secunde\002. Multumesc!"
set black(blackip.ro.20) "\002$blackip(projectName) $blackip(version)\002 realizat de\002 $blackip(author)\002 ($blackip(website))"

# English
###
set black(blackip.en.1) "\[BlackIP\] Use: \002!ip\002 \[ip|\002host\002|nickname\]"
set black(blackip.en.2) "\[\002%msg.1%\002\] is not Online."
set black(blackip.en.3) "\[\002X\002\] unable to resolve address \002%msg.1%\002."
set black(blackip.en.4) "\[\002X\002\] unable to resolve address \002%msg.1%\002 from \002%msg.2%\002."
set black(blackip.en.5) "\002%msg.1%\002 is located in \002%msg.2%\002 (%msg.3%) ; \002TimeZone\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Mobile\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.en.6) "\002%msg.1%\002 is located in \002%msg.2%\002 (%msg.3%) ; \002TimeZone\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Mobile\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.en.9) "\002Nick\002: %msg.2% ; \002Host\002: %msg.1%"
set black(blackip.en.11) "\002Other rDNS\002: %msg.1%"
set black(blackip.en.12) "\002%msg.1%\002 is located in \002%msg.2%\002 (%msg.3%) ; \002TimeZone\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Mobile\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Suspicious\002: %msg.9%"
set black(blackip.en.13) "\002%msg.1%\002 is located in \002%msg.2%\002 (%msg.3%) ; \002TimeZone\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Mobile\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Suspicious\002: %msg.9%"
set black(blackip.en.14) "\002%msg.1%\002 is located in \002%msg.2%\002 (%msg.3%) ; \002TimeZone\002: %msg.4% ; \002ISP\002: %msg.5% ; \002Mobile\002: %msg.7% ; \002Proxy\002: %msg.6%"
set black(blackip.en.15) "\002%msg.1%\002 is located in \002%msg.2%\002 (%msg.3%) ; \002TimeZone\002: %msg.4% ; \002ISP\002: %msg.9% ; \002Mobile\002: %msg.10% ; \002Proxy\002: %msg.5% ; \002Spam\002: %msg.6% ; \002TOR\002: %msg.7% ; \002Suspicious\002: %msg.8%"
set black(blackip.en.16) "\[X\] \002%msg.1%\002 unknown ip address"
set black(blackip.en.17) "true"
set black(blackip.en.18) "false"
set black(blackip.en.19) "\002%msg.2%\002: You're sending requests too fast. Calm down and try again after \002%msg.1% seconds\002. Thanks!"
set black(blackip.en.20) "\002$blackip(projectName) $blackip(version)\002 made by\002 $blackip(author)\002 ($blackip(website))"

# French
###
set black(blackip.fr.1) "\[BlackIP\] Utilisation: \002!ip\002 \[ip|\002host\002|nickname\]"
set black(blackip.fr.2) "\[\002%msg.1%\002\] n'est pas en ligne."
set black(blackip.fr.3) "\[\002X\002\] incapable de resoudre l'adresse \002%msg.1%\002."
set black(blackip.fr.4) "\[\002X\002\] incapable de resoudre l'adresse \002%msg.1%\002 de \002%msg.2%\002."
set black(blackip.fr.5) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002Fuseau horaire\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Portable\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.fr.6) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002TimeZone\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Portable\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.fr.9) "\002Nick\002: %msg.2% ; \002Host\002: %msg.1%"
set black(blackip.fr.11) "\002Autre rDNS\002: %msg.1%"
set black(blackip.fr.12) "\002%msg.1%\002 est situe dans \002%msg.2%\002 (%msg.3%) ; \002Fuseau horaire\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Portable\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Soupconneux\002: %msg.9%"
set black(blackip.fr.13) "\002%msg.1%\002 est situe dans \002%msg.2%\002 (%msg.3%) ; \002Fuseau horaire\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Portable\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Soupconneux\002: %msg.9%"
set black(blackip.fr.14) "\002%msg.1%\002 est situe dans \002%msg.2%\002 (%msg.3%) ; \002Fuseau horaire\002: %msg.4% ; \002ISP\002: %msg.5% ; \002Portable\002: %msg.7% ; \002Proxy\002: %msg.6%"
set black(blackip.fr.15) "\002%msg.1%\002 est situe dans \002%msg.2%\002 (%msg.3%) ; \002Fuseau horaire\002: %msg.4% ; \002ISP\002: %msg.9% ; \002Portable\002: %msg.10% ; \002Proxy\002: %msg.5% ; \002Spam\002: %msg.6% ; \002TOR\002: %msg.7% ; \002Soupconneux\002: %msg.8%"
set black(blackip.fr.16) "\[X\] \002%msg.1%\002 adresse IP inconnue"
set black(blackip.fr.17) "vrai"
set black(blackip.fr.18) "faux"
set black(blackip.fr.19) "\002%msg.2%\002: Vous envoyez des demandes trop rapidement. Calmez-vous et reessayez apres \002%msg.1% secondes\002. Merci!"
set black(blackip.fr.20) "\002$blackip(projectName) $blackip(version)\002 fait par\002 $blackip(author)\002 ($blackip(website))"

# Spanish
###
set black(blackip.es.1) "\[BlackIP\] Uso: \002!ip\002 \[ip|\002host\002|nickname\]"
set black(blackip.es.2) "\[\002%msg.1%\002\] no esta en linea."
set black(blackip.es.3) "\[\002X\002\] incapaz de resolver la direccion \002%msg.1%\002."
set black(blackip.es.4) "\[\002X\002\] incapaz de resolver la direccion \002%msg.1%\002 desde \002%msg.2%\002."
set black(blackip.es.5) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002Zona horaria\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Movil\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.es.6) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002Zona horaria\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Movil\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.es.9) "\002Nick\002: %msg.2% ; \002Host\002: %msg.1%"
set black(blackip.es.11) "\002Otro rDNS\002: %msg.1%"
set black(blackip.es.12) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002Zona horaria\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Movil\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Suspicaz\002: %msg.9%"
set black(blackip.es.13) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002Zona horaria\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Movil\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Suspicaz\002: %msg.9%"
set black(blackip.es.14) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002Zona horaria\002: %msg.4% ; \002ISP\002: %msg.5% ; \002Movil\002: %msg.7% ; \002Proxy\002: %msg.6%"
set black(blackip.es.15) "\002%msg.1%\002 se encuentra en \002%msg.2%\002 (%msg.3%) ; \002Zona horaria\002: %msg.4% ; \002ISP\002: %msg.9% ; \002Movil\002: %msg.10% ; \002Proxy\002: %msg.5% ; \002Spam\002: %msg.6% ; \002TOR\002: %msg.7% ; \002Suspicaz\002: %msg.8%"
set black(blackip.es.16) "\[X\] \002%msg.1%\002 direccion IP desconocida"
set black(blackip.es.17) "verdadero"
set black(blackip.es.18) "falso"
set black(blackip.es.19) "\002%msg.2%\002: Estas enviando solicitudes demasiado rapido. Calmate e intenta de nuevo despues de \002%msg.1% segundos\002. Gracias!"
set black(blackip.es.20) "\002$blackip(projectName) $blackip(version)\002 hecho por\002 $blackip(author)\002 ($blackip(website))"

# Italian
###
set black(blackip.it.1) "\[BlackIP\] Use: \002!ip\002 \[ip|\002host\002|nickname\]"
set black(blackip.it.2) "\[\002%msg.1%\002\] non e online."
set black(blackip.it.3) "\[\002X\002\] incapace di risolvere l'indirizzo \002%msg.1%\002."
set black(blackip.it.4) "\[\002X\002\] incapace di risolvere l'indirizzo \002%msg.1%\002 da \002%msg.2%\002."
set black(blackip.it.5) "\002%msg.1%\002 si trova in \002%msg.2%\002 (%msg.3%) ; \002Fuso orario\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Mobile\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.it.6) "\002%msg.1%\002 si trova in \002%msg.2%\002 (%msg.3%) ; \002Fuso orario\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.6% ; \002Mobile\002: %msg.8% ; \002Proxy\002: %msg.7%"
set black(blackip.it.9) "\002Nick\002: %msg.2% ; \002Host\002: %msg.1%"
set black(blackip.it.11) "\002Altro rDNS\002: %msg.1%"
set black(blackip.it.12) "\002%msg.1%\002 si trova in \002%msg.2%\002 (%msg.3%) ; \002Fuso orario\002: %msg.4% ; \002IP\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Mobile\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Sospetto\002: %msg.9%"
set black(blackip.it.13) "\002%msg.1%\002 si trova in \002%msg.2%\002 (%msg.3%) ; \002Fuso orario\002: %msg.4% ; \002Host\002: %msg.5% ; \002ISP\002: %msg.10% ; \002Mobile\002: %msg.11% ; \002Proxy\002: %msg.6% ; \002Spam\002: %msg.7% ; \002TOR\002: %msg.8% ; \002Sospetto\002: %msg.9%"
set black(blackip.it.14) "\002%msg.1%\002 si trova in \002%msg.2%\002 (%msg.3%) ; \002Fuso orario\002: %msg.4% ; \002ISP\002: %msg.5% ; \002Mobile\002: %msg.7% ; \002Proxy\002: %msg.6%"
set black(blackip.it.15) "\002%msg.1%\002 si trova in \002%msg.2%\002 (%msg.3%) ; \002Fuso orario\002: %msg.4% ; \002ISP\002: %msg.9% ; \002Mobile\002: %msg.10% ; \002Proxy\002: %msg.5% ; \002Spam\002: %msg.6% ; \002TOR\002: %msg.7% ; \002Sospetto\002: %msg.8%"
set black(blackip.it.16) "\[X\] \002%msg.1%\002 indirizzo IP sconosciuto"
set black(blackip.it.17) "vero"
set black(blackip.it.18) "falso"
set black(blackip.it.19) "\002%msg.2%\002: Stai inviando richieste troppo velocemente. Calmati e riprova dopo \002%msg.1% secondi\002. Grazie!"
set black(blackip.it.20) "\002$blackip(projectName) $blackip(version)\002 prodotto da\002 $blackip(author)\002 ($blackip(website))"

putlog "\002$blackip(projectName) $blackip(version)\002 coded by\002 $blackip(author)\002 ($blackip(website)): Loaded & initialized.."

#######################
#######################################################################################################
###                  *** END OF BlackIP TCL ***                                                     ###
#######################################################################################################
