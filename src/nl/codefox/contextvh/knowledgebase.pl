%%% Percepts that the agent receives from the environment
:- dynamic settings/1.
:- dynamic functions/1.
:- dynamic indicators/1.
:- dynamic lands/1.

% others
:- dynamic upgrade_type/3.
:- dynamic indicatorLink/2.
:- dynamic indicator/4.
:- dynamic stakeholder/4.
:- dynamic building/8.
:- dynamic zones/1.
:- dynamic zone/5. 
:- dynamic actionlog/4.
:- dynamic actions/1.

%%% Knowledge
:- dynamic demolished/1.
:- dynamic constructed/1.
:- dynamic upgraded/1.
:- dynamic improvedZone/1.
:- dynamic myBuildingList/1.
:- dynamic emptyPoly/1.
:- dynamic requestedLand/2.
:- dynamic offeredLand/2.

% Goals that can be adopted
demolishBuilding(BuildingID) :- demolished(BuildingID).
constructBuilding(BuildingID) :- constructed(BuildingID).
upgradeBuilding(UpgradeID, MultiPolygon) :- upgraded(MultiPolygon).
improveZone(IndicatorID, ZoneID) :- improvedZone(IndicatorID, ZoneID).

% we achieve these goals when we have tried 3 times or when we actually bought or sold land.
doneBuying(MultiPoly) :- (requestedLand(MultiPoly, Counter), Counter >= 3) ; ourLand(MultiPoly).
doneSelling(MultiPoly) :- (offeredLand(MultiPoly, Counter), Counter >= 3); landOfOthers(MultiPoly).

% check if our agent owns a building
ownedBuilding(BuildingID) :- building(BuildingID,_,OwnerID,_,_,_,_,_), stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', Money, Income), StakeholderID = OwnerID. 

% Budget of our Stakeholder
budget(Amount) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', Amount, Income).
% Stakeholder ID for our Stakeholder
ourID(StakeholderID) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', Money, Income).
% Stakeholder IDs for other stakeholders
notOurID(StakeholderID) :- stakeholder(StakeholderID, _, _, _), not(ourID(StakeholderID)).

% predicates to determine if land on the map is ours or others
landOfOthers(MultiPoly) :- lands(List), stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', _, _), not(member(land(LandID, stakeholder(StakeholderID,_,_,_), MultiPoly, _, _), List)), MultiPoly \= multipolygon('MULTIPOLYGON EMPTY').
ourLand(MultiPoly) :- lands(List), stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', _, _), member(land(LandID, stakeholder(StakeholderID,_,_,_), MultiPoly, _, _), List), MultiPoly \= multipolygon('MULTIPOLYGON EMPTY').

%Uses indicator scores to determine whether more Luxury houses are desirable, if this is not the case Normal houses are desirable.  
needLuxeHouse:- indicator(34,_, _, ZoneLinkList), member(zone_link(0,_,Current1,Target1), ZoneLinkList), 
indicator(34,_, _, ZoneLinkList), member(zone_link(1,_,Current2,Target2), ZoneLinkList),
Target1 - Current1 > Target2 - Current2.

% determine when a zone needs to be improved and for which indicator
needImprovement(IndicatorID, ZoneID) :- indicator(IndicatorID, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue < CurrentTarget.  
% a zone is improved when the indicator score is higher or equal to the agent's target
improvedZone(IndicatorID, ZoneID) :- indicator(IndicatorID, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue >= CurrentTarget.

