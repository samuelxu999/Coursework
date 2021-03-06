#!/usr/bin/tclsh

#calculate probability distribution for selected letter string
proc cal_array_prob	info_string {
	#set data [exec ./sort_statistic.sh alice30.txt | head -30]
	#set data [string toupper [regsub -all {[^A-Za-z]} [read stdin] ""]]
	set data [string toupper [read stdin] ]
	#puts "$info_string"
	puts "array set Pr_array { [ join $data ] }"
	#puts $data
	set i 0
	#foreach x $data {		
	#	lappend loutput $x		
	#}
	
	#foreach x y loutput {		
	#	puts "$x\t$y"		
	#}
	
}


proc cal_prob  type_sample {
	#A-Alice.txt P[S|A]
	array set Pr_array_A { THE 0.055779 AND 0.029334 TO 0.026518 A 0.022495 I 0.019861 IT 0.019276 SHE 0.018617 OF 0.018288 SAID 0.016679 ALICE 0.014448 IN 0.013021 WAS 0.012875 YOU 0.012619 THAT 0.010059 AS 0.008998 HER 0.008888 T 0.007901 AT 0.007388 S 0.007132 ON 0.006913 HAD 0.006474 WITH 0.006401 ALL 0.006328 BE 0.005304 FOR 0.005121 BUT 0.004865 THEY 0.004755 NOT 0.004718 VERY 0.004609 LITTLE 0.004572 SO 0.004535 OUT 0.004243 THIS 0.004133 THE 0.003950 HE 0.003694 DOWN 0.003621 UP 0.003584 IS 0.003548 ABOUT 0.003438 HIS 0.003438 ONE 0.003438 WHAT 0.003402 THEM 0.003219 KNOW 0.003182 WERE 0.003109 LIKE 0.003072 AGAIN 0.003036 HERSELF 0.003036 WENT 0.003036 IF 0.002853 OR 0.002780 QUEEN 0.002707 THOUGHT 0.002707 COULD 0.002670 HAVE 0.002670 THEN 0.002634 WOULD 0.002560 NO 0.002524 WHEN 0.002524 DO 0.002487 TIME 0.002487 AND 0.002451 INTO 0.002451 SEE 0.002414 THERE 0.002377 IT 0.002341 OFF 0.002268 KING 0.002231 ME 0.002231 DID 0.002195 TURTLE 0.002158 BEGAN 0.002121 M 0.002121 CAN 0.002085 ITS 0.002048 LL 0.002048 MOCK 0.002048 WAY 0.002048 GRYPHON 0.002012 HATTER 0.002012 MY 0.002012 BY 0.001975 QUITE 0.001939 YOUR 0.001939 AN 0.001902 DON 0.001865 MUCH 0.001865 SAY 0.001865 YOU 0.001865 HEAD 0.001829 THEIR 0.001829 THINK 0.001829 THING 0.001792 NOW 0.001756 SOME 0.001756 WHO 0.001756 GO 0.001719 MORE 0.001719 ONLY 0.001719 VOICE 0.001719 GOT 0.001646 JUST 0.001646 LOOKED 0.001646 RABBIT 0.001646 ARE 0.001609 FIRST 0.001609 GET 0.001609 VE 0.001573 NEVER 0.001536 WHAT 0.001536 DUCHESS 0.001500 MUST 0.001500 ROUND 0.001500 WHICH 0.001500 CAME 0.001463 DORMOUSE 0.001463 HOW 0.001463 OTHER 0.001463 OVER 0.001463 SUCH 0.001463 TONE 0.001463 WELL 0.001463 ANY 0.001426 GREAT 0.001426 HERE 0.001426 HIM 0.001426 SHE 0.001426 BACK 0.001390 BEEN 0.001390 RE 0.001390 AFTER 0.001353 BUT 0.001353 BEFORE 0.001317 OH 0.001280 FROM 0.001244 MARCH 0.001244 LARGE 0.001207 THERE 0.001207 LAST 0.001170 LOOKING 0.001170 TWO 0.001170 HARE 0.001134 LONG 0.001134 MOMENT 0.001134 ONCE 0.001134 PUT 0.001134 THINGS 0.001134 DOOR 0.001097 FOUND 0.001097 HEARD 0.001097 MADE 0.001097 MOUSE 0.001097 NOTHING 0.001097 RIGHT 0.001097 DAY 0.001061 EYES 0.001061 REPLIED 0.001061 DEAR 0.001024 LOOK 0.001024 MIGHT 0.001024 NEXT 0.001024 THREE 0.001024 CATERPILLAR 0.000988 D 0.000988 GOING 0.000988 HOW 0.000988 MAKE 0.000988 SEEMED 0.000988 SHOULD 0.000988 SO 0.000988 TELL 0.000988 THAT 0.000988 WHY 0.000988 CAT 0.000951 COURSE 0.000951 GOOD 0.000951 UPON 0.000951 WITHOUT 0.000951 WON 0.000951 AWAY 0.000914 COME 0.000914 POOR 0.000914 RATHER 0.000914 TOO 0.000914 SOON 0.000878 WILL 0.000878 ADDED 0.000841 FELT 0.000841 SAME 0.000841 SHALL 0.000841 THAN 0.000841 TOOK 0.000841 WE 0.000841 WELL 0.000841 ANOTHER 0.000805 GETTING 0.000805 HALF 0.000805 JURY 0.000805 WHITE 0.000805 COME 0.000768 FIND 0.000768 MINUTE 0.000768 THEN 0.000768 THEY 0.000768 TILL 0.000768 WISH 0.000768 WORDS 0.000768 YET 0.000768 CRIED 0.000732 EVER 0.000732 HAND 0.000732 HE 0.000732 NO 0.000732 SORT 0.000732 SURE 0.000732 WHILE 0.000732 ANYTHING 0.000695 BEING 0.000695 CURIOUS 0.000695 FEET 0.000695 TRIED 0.000695 ENOUGH 0.000658 HOUSE 0.000658 TAKE 0.000658 TEA 0.000658 USE 0.000658 WONDER 0.000658 A 0.000622 AS 0.000622 ASKED 0.000622 COURT 0.000622 EAT 0.000622 END 0.000622 EVEN 0.000622 OLD 0.000622 QUESTION 0.000622 SAT 0.000622 SIDE 0.000622 SOMETHING 0.000622 SPOKE 0.000622 TABLE 0.000622 THIS 0.000622 AM 0.000585 BILL 0.000585 BIT 0.000585 DOESN 0.000585 GARDEN 0.000585 HASTILY 0.000585 IF 0.000585 RAN 0.000585 TALKING 0.000585 TURNED 0.000585 UNDER 0.000585 AIR 0.000549 ARM 0.000549 CALLED 0.000549 DONE 0.000549 FACE 0.000549 HIGH 0.000549 IDEA 0.000549 INDEED 0.000549 LOW 0.000549 SAYING 0.000549 SEEN 0.000549 WHO 0.000549 YOU 0.000549 ANXIOUSLY 0.000512 BABY 0.000512 BECAUSE 0.000512 BEGINNING 0.000512 BETTER 0.000512 BOTH 0.000512 DIDN 0.000512 DINAH 0.000512 HEAR 0.000512 ITSELF 0.000512 KNEW 0.000512 LEFT 0.000512 MAD 0.000512 MOUSE 0.000512 NEAR 0.000512 OUGHT 0.000512 PERHAPS 0.000512 REMEMBER 0.000512 SAW 0.000512 SEA 0.000512 SET 0.000512 TALK 0.000512 TRYING 0.000512 US 0.000512 BEHIND 0.000475 CATS 0.000475 CERTAINLY 0.000475 CHANGE 0.000475 CLOSE 0.000475 COOK 0.000475 DANCE 0.000475 DO 0.000475 DODO 0.000475 FAR 0.000475 }
	
	#bwest.txt P[S|A]
	array set Pr_array_B { THE 0.056985 OF 0.039401 AND 0.032888 TO 0.025399 A 0.022143 THE 0.022143 IN 0.019212 ARE 0.016607 IS 0.011071 OR 0.009769 ON 0.008466 WITH 0.006838 BY 0.006187 FOR 0.005861 YOU 0.005861 NORTH 0.005536 HAVE 0.005210 BE 0.004884 DAY 0.004884 WE 0.004884 IT 0.004559 FROM 0.004233 LIFE 0.004233 AS 0.003908 NORTHERN 0.003908 A 0.003582 AIRCRAFT 0.003582 S 0.003582 FISHING 0.003256 ICE 0.003256 MAY 0.003256 THAT 0.003256 MANY 0.002931 OUR 0.002931 UP 0.002931 WINTER 0.002931 ALL 0.002605 AN 0.002605 AT 0.002605 IN 0.002605 MORE 0.002605 THEY 0.002605 FISH 0.002279 HUNTING 0.002279 LAKE 0.002279 LAKES 0.002279 MUST 0.002279 NOT 0.002279 THEIR 0.002279 THEY 0.002279 WERE 0.002279 CAN 0.001954 FOOD 0.001954 HOME 0.001954 IF 0.001954 LARGE 0.001954 MILES 0.001954 MOST 0.001954 ONE 0.001954 SOME 0.001954 WE 0.001954 YOUR 0.001954 DO 0.001628 DOWN 0.001628 EQUIPMENT 0.001628 FOR 0.001628 FRESH 0.001628 HIS 0.001628 IF 0.001628 NEW 0.001628 ROADS 0.001628 SERVICES 0.001628 SOUTHERN 0.001628 THAN 0.001628 TRIP 0.001628 TV 0.001628 WHEN 0.001628 ANOTHER 0.001303 AREAS 0.001303 AVAILABLE 0.001303 AWAY 0.001303 BUT 0.001303 CAR 0.001303 CITY 0.001303 COLD 0.001303 COMMUNITIES 0.001303 DEGREES 0.001303 ENGINES 0.001303 FEW 0.001303 FLIGHT 0.001303 HAD 0.001303 HAS 0.001303 HEAR 0.001303 LEFT 0.001303 LIVE 0.001303 LOCAL 0.001303 MOOSE 0.001303 MOST 0.001303 MOVE 0.001303 NEIGHBORS 0.001303 PILOT 0.001303 PILOTS 0.001303 PRICES 0.001303 ROAD 0.001303 SEASONS 0.001303 SHORE 0.001303 SMALL 0.001303 SO 0.001303 SOUTH 0.001303 SUMMER 0.001303 THEM 0.001303 THEN 0.001303 THERE 0.001303 THESE 0.001303 THICK 0.001303 TO 0.001303 TROUT 0.001303 WAS 0.001303 YEAR 0.001303 YEARS 0.001303 ANY 0.000977 ARCTIC 0.000977 AS 0.000977 BEEN 0.000977 BOATS 0.000977 BREAKING 0.000977 BUS 0.000977 BUSH 0.000977 BUT 0.000977 CABIN 0.000977 CARRY 0.000977 CENTER 0.000977 CHANGE 0.000977 CIVILIZATION 0.000977 COFFEE 0.000977 CONDITIONS 0.000977 COURSE 0.000977 DELIVERY 0.000977 DOG 0.000977 DUCKS 0.000977 DURING 0.000977 EACH 0.000977 ENJOYED 0.000977 EQUIPPED 0.000977 FAVORITE 0.000977 FIRST 0.000977 FISHERMEN 0.000977 FLIES 0.000977 FLY 0.000977 FLYING 0.000977 GAS 0.000977 GET 0.000977 GREAT 0.000977 HOURS 0.000977 HUNDREDS 0.000977 INTO 0.000977 IT 0.000977 LIVES 0.000977 LOON 0.000977 MADE 0.000977 MAN 0.000977 MANY 0.000977 MISS 0.000977 MOTORS 0.000977 NEVER 0.000977 NIGHT 0.000977 NO 0.000977 OIL 0.000977 ON 0.000977 ONLY 0.000977 OTHER 0.000977 OUT 0.000977 OWN 0.000977 PEOPLE 0.000977 PER 0.000977 PROBLEM 0.000977 PROBLEMS 0.000977 REGULAR 0.000977 REMOTE 0.000977 SAME 0.000977 SERVICE 0.000977 SETTLEMENTS 0.000977 SHORT 0.000977 SIDE 0.000977 SKIS 0.000977 SNOW 0.000977 SOME 0.000977 START 0.000977 TAKE 0.000977 TAXI 0.000977 THERE 0.000977 THIS 0.000977 THOSE 0.000977 TOO 0.000977 TOWN 0.000977 TRANSPORT 0.000977 TRAVEL 0.000977 USE 0.000977 USUALLY 0.000977 VEHICLES 0.000977 WATER 0.000977 WHICH 0.000977 WILL 0.000977 YOU 0.000977 ACTIVITIES 0.000651 AFTER 0.000651 AIR 0.000651 AIRPORT 0.000651 ALL 0.000651 ALSO 0.000651 AMENITIES 0.000651 ANCESTRY 0.000651 APPLIANCES 0.000651 AROUND 0.000651 ARRIVAL 0.000651 ARRIVE 0.000651 AT 0.000651 BACK 0.000651 BAIT 0.000651 BASIS 0.000651 BEAR 0.000651 BEAVER 0.000651 BECAUSE 0.000651 BECOMES 0.000651 BEFORE 0.000651 BEGIN 0.000651 BELOW 0.000651 BIRD 0.000651 BLACK 0.000651 BLUEBERRIES 0.000651 BUZZ 0.000651 CARRIED 0.000651 CASE 0.000651 CHILDREN 0.000651 CLOTHING 0.000651 COMMUNITY 0.000651 CONSTRUCTION 0.000651 CONTACT 0.000651 COST 0.000651 COTTAGES 0.000651 COVERED 0.000651 CRY 0.000651 DAILY 0.000651 DANGER 0.000651 DIFFERENT 0.000651 DIFFICULT 0.000651 DRIVE 0.000651 DWELLERS 0.000651 EFFORT 0.000651 EGGS 0.000651 ELECTRIC 0.000651 EMPLOYMENT 0.000651 ENGINE 0.000651 ENJOY 0.000651 ENSURE 0.000651 ESPECIALLY 0.000651 EVEN 0.000651 EVENING 0.000651 EXPERIENCE 0.000651 FACILITIES 0.000651 FAMILY 0.000651 FARTHER 0.000651 FEEDING 0.000651 FIRE 0.000651 FIVE 0.000651 FLIGHTS 0.000651 FOUR 0.000651 FREIGHT 0.000651 FRIENDS 0.000651 FUEL 0.000651 GASOLINE 0.000651 GASOLINE 0.000651 GEESE 0.000651 GOVERNMENT 0.000651 GROUND 0.000651 HE 0.000651 HEARD 0.000651 HEAVY 0.000651 HERE 0.000651 HIGH 0.000651 HIGHER 0.000651 HOLES 0.000651 HOMES 0.000651 HUNTER 0.000651 IS 0.000651 IS 0.000651 JIM 0.000651 KEPT 0.000651 LACK 0.000651 LAND 0.000651 LANDING 0.000651 LAWN 0.000651 LIKE 0.000651 LINE 0.000651 LIVING 0.000651 LOGGING 0.000651 MAIL 0.000651 MAJOR 0.000651 MEDEVAC 0.000651 MONTHS 0.000651 }
	
	set data [string toupper [read stdin] ]
	set sum 1
	set sum_wd 0
	foreach {wd_sam wd_v} $data {
		foreach wd_pool_a [array names Pr_array_A] {
			if { $wd_sam==$wd_pool_a } {
				foreach wd_pool_b [array names Pr_array_B] {
					if { $wd_sam==$wd_pool_b } {
						#calucate P[A|S]
						if { $type_sample=="A" } {							
							set sum [ expr {$sum+($wd_v*$Pr_array_A($wd_sam))/($Pr_array_A($wd_sam)+$Pr_array_B($wd_sam))}]
						}
						#calucate P[B|S]
						if { $type_sample=="B" } {							
							set sum [ expr {$sum+($wd_v*$Pr_array_B($wd_sam))/($Pr_array_A($wd_sam)+$Pr_array_B($wd_sam))}]
						}										
					#puts $Pr_array_A($wd_sam)
					break	
					}
			
				}		
			}	
		}
		set sum_wd [expr $sum_wd+1]
	}
	#puts $sum_wd
	puts [expr $sum/$sum_wd]		
}


lassign $argv type 

if { $type==" " } {
	puts "usage: [sample type-A or B]"
	exit 0
}

#./sort_statistic.sh alice30.txt | head -30 | ./make_bayes.tcl

#cal_array_prob "Test"

cal_prob $type 





 



