############################################################################
# BlackIP 1.7
# - returns IPs (both IPv4 & IPv6) dns, location & organization information for a nick/IP/hostname.
#
# requires: packages http and json
#
# USAGE: !ip <ip> / <host> / <nickname>
#
# UPDATES/CHANGES:
# - Changed source website
# - Now supports IPv6
# - Now supports eggdrop version less than 1.8.*
# - Now with multi-language support
#
# To activate .chanset #channel +ip | BlackTools : .set +ip
# 
# To chose a different language .set iplang <RO> / <EN> / <FR> / <ES> / <IT>
#
# To work, put the two tcl's in config from the arhive: json.tcl , http.tcl
#					  (if you don't have them instaled)
#
#                                             BLaCkShaDoW ProductionS
#		                	        WwW.TclScripts.Net       
###########################################################################

package require http
package require json

###
# set here who can execute the command (-|- for all)
###
set ip_flags "-|-"

###
# Bindings
# - using commands
###
bind pub $ip_flags !ip black:ip:check

###
# Channel flags
# - to activate the script: .set +ip or .chanset #channel +ip
#
# - to set script language:
# .set iplang <ro/en/fr/es> or .chanset #channel iplang <ro/en/fr/es/it>
###
setudef flag ip
setudef str iplang

############################################################################

###
# Functions
# Do NOT touch unless you know what you are doing
###

proc black:ip:check {nick host hand chan arg} {
	set ip [lindex [split $arg] 0]
	set ::chan $chan
	set ::ip $ip

if {![channel get $chan ip]} {
return
}

if {$ip == ""} {
	blackip:tell $nick $chan 1 none
	return
}
	set check_ipv6 [regexp {^([0-9A-Fa-f]{0,4}:){2,7}([0-9A-Fa-f]{1,4}$|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$} $ip]
	set check_ipv4 [regexp {^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$} $ip]
	
if {![string match -nocase "*:*" $ip] && ![string match -nocase "*.*" $ip]} {
	putserv "WHOIS $ip"
	bind raw - 401 no:nick
	bind raw - 311 check:for:nick
	return
}
if {$check_ipv6 == "0" && $check_ipv4 == "0"} {
	set getv6 [catch {exec host -t AAAA $ip 2>/dev/null} results]
	set check_ipv6 [regexp {^([0-9A-Fa-f]{0,4}:){2,7}([0-9A-Fa-f]{1,4}$|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$} [lindex $results 4]]
if {$check_ipv6 == "1"} {
	check:ip [lindex $results 4] $chan 2 $ip
	return
}
	dnslookup $ip solve:ip $chan
	return
}
	check:ip $ip $chan 0 none
}

proc no:nick { from keyword arguments } {
	set chan $::chan
	set ip $::ip
	blackip:tell "" $chan 2 $ip
	unbind raw - 401 no:nick
	unbind raw - 311 check:for:nick
}

proc solve:ip {ip host receive chan} {
if {$receive == "1"} {
	check:ip $ip $chan 2 $host
	} else {
	blackip:tell "" $chan 3 $host
	}
}

proc solve:nick:ip {ip host receive chan nick} {
if {$receive == "1"} {
	check:ip $ip $chan 3 "$host $nick"
	} else {
	blackip:tell "" $chan 4 "$host~$nick"
	}
}

proc check:for:nick { from keyword arguments } {

	set chan $::chan
	set getip [lindex [split $arguments] 3]
	set getnick [lindex [split $arguments] 1]

	set check_ipv6 [regexp {^([0-9A-Fa-f]{0,4}:){2,7}([0-9A-Fa-f]{1,4}$|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$} $getip]
	set check_ipv4 [regexp {^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$} $getip]
if {$check_ipv6 == "0" && $check_ipv4 == "0"} {
	set getv6 [catch {exec host -t AAAA $getip 2>/dev/null} results]
	set check_ipv6 [regexp {^([0-9A-Fa-f]{0,4}:){2,7}([0-9A-Fa-f]{1,4}$|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$} [lindex $results 4]]
if {$check_ipv6 == "1"} {
	check:ip [lindex $results 4] $chan 3 "$getip $getnick"
	unbind raw - 311 check:for:nick
	unbind raw - 401 no:nick
	return
}
	dnslookup $getip solve:nick:ip $chan $getnick
	unbind raw - 311 check:for:nick
	unbind raw - 401 no:nick
	return
}
	check:ip $getip $chan 0 $getnick
	unbind raw - 311 check:for:nick
	unbind raw - 401 no:nick
}


proc check:ip {ip chan status arg} {
global botnick
	set noinfo 0
	set ipq [http::config -useragent "lynx"]
	set ipq [::http::geturl "http://ip-api.com/json/$ip"] 
	set data [http::data $ipq]
	::http::cleanup $ipq
	set parse [::json::json2dict $data]  
	set location ""
	set hostname ""
	set org ""
foreach {name info} $parse {
if {[string equal -nocase $name "hostname"]} {
if {$info != "No Hostname"} {
	set hostname $info
	}
}
if {[string equal -nocase $name "city"]} {
if {$info != ""} {
	lappend location $info
	}
}

if {[string equal -nocase $name "regionName"]} {
if {$info != ""} {
	lappend location $info
	}
}

if {[string equal -nocase $name "country"]} {
if {$info != ""} {
	lappend location $info
	}
}
if {[string equal -nocase $name "org"]} {
if {$info != ""} {
	set org $info
		}
	}
if {[string equal -nocase $name "status"]} {
if {$info != ""} {
if {$info == "fail"} {
	set noinfo 1
			}
		}
	}
}

if {$noinfo == "1"} {
	blackip:tell "" $chan 13 $ip
	return
}

if {$org != ""} {
	set org_text ";\00302 ORG: \00310$org\003"
} else { set org_text "" }
	set location [join $location ", "]
if {$status != 0} {
	
if {$status == "1"} {
if {$hostname != ""} {
	blackip:tell "" $chan 5 "$arg~$ip~$hostname~$location~$org"
} else {
	blackip:tell "" $chan 6 "$arg~$ip~$location~$org"
	} 
}
if {$status == "2"} { 
	blackip:tell "" $chan 7 "$arg~$ip~$location~$org"	
}

if {$status == "3"} {
	set nickname [lindex [split $arg] 1]
	set host [lindex [split $arg] 0]
	blackip:tell "" $chan 9 "$host~$nickname"
if {$hostname != ""} {
	blackip:tell "" $chan 8 "$ip~$hostname~$location~$org"	
} else {
	blackip:tell "" $chan 10 "$ip~$location~$org"
	}
}
} else {
if {$hostname != ""} {
	blackip:tell "" $chan 11 "$ip~$hostname~$location~$org"
} else {
	blackip:tell "" $chan 12 "$ip~$location~$org"
		}
	}
}

proc blackip:tell {nick chan type arg} {
	global black
	set arg_s [split $arg "~"]
	set inc 0
foreach s $arg_s {
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

proc blackip:getlang {chan} {
	global black
	set getlang [string tolower [channel get $chan iplang]]
if {$getlang == ""} {
	set lang "en"
} else {
if {[info exists black(blackip.$getlang.1)]} {
	set lang $getlang
} else { 
	set lang "en"
		}
	}
	return $lang
}

set blackip(projectName) "BlackIP"
set blackip(author) "BLaCkShaDoW"
set blackip(website) "wWw.TCLScriptS.NeT"
set blackip(version) "1.7 (IPv6 support)"

#Languages

# Romanian

set black(blackip.ro.1) "\[BlackIP\] Foloseste: \002!ip\002 <ip> / <\002host\002> / <nickname>"
set black(blackip.ro.2) "\[\00304%msg.1%\003]\ nu este online."
set black(blackip.ro.3) "\[\00304X\003\] nu am putut rezolva adresa \00314%msg.1%\003."
set black(blackip.ro.4) "\[\00304X\003\] nu am putut rezolva adresa \00314%msg.1%\003 apartinand lui \00303%msg.2%\003."
set black(blackip.ro.5) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 | \00302Host: \00304%msg.3%\003 |\00302 Locatie: \00314%msg.4%\003 |\00302 ORG: \00310%msg.5%\003"
set black(blackip.ro.6) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Locatie: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.ro.7) "\00302Host: \00306%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Locatie: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.ro.8) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Locatie: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.ro.9) "\00302Nick: \00303%msg.2%\003 | \00302Host: \00306%msg.1%\003"
set black(blackip.ro.10) "\00302IP: \00304%msg.1%\003 |\00302 Locatie: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.ro.11) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Locatie: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.ro.12) "\00302IP: \00304%msg.1%\003 |\00302 Locatie: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.ro.13) "\[\00304X\003\] \00303%msg.1%\003 adresa IP necunoscuta"

# English

set black(blackip.en.1) "\[BlackIP\] USAGE: \002!ip\002 <ip> / <\002host\002> / <nickname>"
set black(blackip.en.2) "\[\00304%msg.1%\003]\ is not Online."
set black(blackip.en.3) "\[\00304X\003\] unable to resolve address \00314%msg.1%\003."
set black(blackip.en.4) "\[\00304X\003\] unable to resolve address \00314%msg.1%\003 from \00303%msg.2%\003."
set black(blackip.en.5) "\00302NickName: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 | \00302Host: \00304%msg.3%\003 |\00302 Location: \00314%msg.4%\003 |\00302 ORG: \00310%msg.5%\003"
set black(blackip.en.6) "\00302NickName: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Location: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.en.7) "\00302Host: \00306%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Location: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.en.8) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Location: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.en.9) "\00302NickName: \00303%msg.2%\003 | \00302Host: \00306%msg.1%\003"
set black(blackip.en.10) "\00302IP: \00304%msg.1%\003 |\00302 Location: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.en.11) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Location: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.en.12) "\00302IP: \00304%msg.1%\003 |\00302 Location: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.en.13) "\[\00304X\003\] \00303%msg.1%\003 unknown ip address"

# French

set black(blackip.fr.1) "\[BlackIP\] Utilisation: \002!ip\002 <ip> / <\002host\002> / <nickname>"
set black(blackip.fr.2) "\[\00304%msg.1%\003]\ n'est pas en ligne."
set black(blackip.fr.3) "\[\00304X\003\] incapable de resoudre l'adresse \00314%msg.1%\003."
set black(blackip.fr.4) "\[\00304X\003\] incapable de resoudre l'adresse \00314%msg.1%\003 de \00303%msg.2%\003."
set black(blackip.fr.5) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 | \00302Host: \00304%msg.3%\003 |\00302 Localisation: \00314%msg.4%\003 |\00302 ORG: \00310%msg.5%\003"
set black(blackip.fr.6) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Localisation: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.fr.7) "\00302Host: \00306%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Localisation: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.fr.8) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Localisation: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.fr.9) "\00302Nick: \00303%msg.2%\003 | \00302Host: \00306%msg.1%\003"
set black(blackip.fr.10) "\00302IP: \00304%msg.1%\003 |\00302 Localisation: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.fr.11) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Localisation: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.fr.12) "\00302IP: \00304%msg.1%\003 |\00302 Localisation: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.fr.13) "\[\00304X\003\] \00303%msg.1%\003 adresse IP inconnue"

# Spanish

set black(blackip.es.1) "\[BlackIP\] Uso: \002!ip\002 <ip> / <\002host\002> / <nickname>"
set black(blackip.es.2) "\[\00304%msg.1%\003]\ no esta en linea."
set black(blackip.es.3) "\[\00304X\003\] incapaz de resolver la direccion \00314%msg.1%\003."
set black(blackip.es.4) "\[\00304X\003\] incapaz de resolver la direccion \00314%msg.1%\003 desde \00303%msg.2%\003."
set black(blackip.es.5) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 | \00302Host: \00304%msg.3%\003 |\00302 Localizacion: \00314%msg.4%\003 |\00302 ORG: \00310%msg.5%\003"
set black(blackip.es.6) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Localizacion: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.es.7) "\00302Host: \00306%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Localizacion: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.es.8) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Localizacion: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.es.9) "\00302Nick: \00303%msg.2%\003 | \00302Host: \00306%msg.1%\003"
set black(blackip.es.10) "\00302IP: \00304%msg.1%\003 |\00302 Localizacion: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.es.11) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Localizacion: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.es.12) "\00302IP: \00304%msg.1%\003 |\00302 Localizacion: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.es.13) "\[\00304X\003\] \00303%msg.1%\003 direccion IP desconocida"

# Italian

set black(blackip.it.1) "\[BlackIP\] USAGE: \002!ip\002 <ip> / <\002host\002> / <nickname>"
set black(blackip.it.2) "\[\00304%msg.1%\003]\ non e online."
set black(blackip.it.3) "\[\00304X\003\] incapace di risolvere l'indirizzo \00314%msg.1%\003."
set black(blackip.it.4) "\[\00304X\003\] incapace di risolvere l'indirizzo \00314%msg.1%\003 da \00303%msg.2%\003."
set black(blackip.it.5) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 | \00302Host: \00304%msg.3%\003 |\00302 Localizzazione: \00314%msg.4%\003 |\00302 ORG: \00310%msg.5%\003"
set black(blackip.it.6) "\00302Nick: \00303%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Localizzazione: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.it.7) "\00302Host: \00306%msg.1%\003 | \00302IP: \00304%msg.2%\003 |\00302 Localizzazione: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.it.8) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Localizzazione: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.it.9) "\00302Nick: \00303%msg.2%\003 | \00302Host: \00306%msg.1%\003"
set black(blackip.it.10) "\00302IP: \00304%msg.1%\003 |\00302 Localizzazione: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.it.11) "\00302IP: \00304%msg.1%\003 | \00302Host: \00304%msg.2%\003 |\00302 Localizzazione: \00314%msg.3%\003 |\00302 ORG: \00310%msg.4%\003"
set black(blackip.it.12) "\00302IP: \00304%msg.1%\003 |\00302 Localizzazione: \00314%msg.2%\003 |\00302 ORG: \00310%msg.3%\003"
set black(blackip.it.13) "\[\00304X\003\] \00303%msg.1%\003 indirizzo IP sconosciuto"

putlog "\002$blackip(projectName) v$blackip(version)\002 coded by $blackip(author) ($blackip(website)): Loaded."

##############
##########################################################
##   END                                                 #
##########################################################
