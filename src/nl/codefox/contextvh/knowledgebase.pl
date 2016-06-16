%%% Percepts that the agent receives from the environment
:- dynamic stakeholders/1.
:- dynamic functions/1.
:- dynamic indicators/1.
:- dynamic lands/1.
:- dynamic zones/1.
:- dynamic buildings/1.
:- dynamic settings/1.
:- dynamic actions/1.
:- dynamic request/10.

:- dynamic stakeholder/4.
:- dynamic function/3.
:- dynamic indicator/4.
:- dynamic land/5.
:- dynamic zone/5. 
:- dynamic building/9.
:- dynamic relevant_areas/2.

% others
:- dynamic indicatorLink/2.
:- dynamic actionlog/4.
:- dynamic upgrade_type/2.

%%% Defined knowledge
:- dynamic demolished/1.
:- dynamic constructed/1.
:- dynamic upgraded/1.
:- dynamic improvedZone/1.
:- dynamic myBuildingList/1.
:- dynamic emptyPoly/1.
:- dynamic requestedLand/2.
:- dynamic offeredLand/2.
:- dynamic doneBuying/1.

%%% Goals that can be adopted
demolishBuilding(BuildingID) :- demolished(BuildingID).
constructBuilding(MultiPoly) :- constructed(MultiPoly).
upgradeBuilding(UpgradeID,MultiPolygon) :- upgraded(MultiPolygon).
improveZone(IndicatorID,ZoneID) :- improvedZone(IndicatorID,ZoneID).
% we achieve these goals when we have tried 3 times or when we actually bought or sold land.

doneSelling(MultiPoly) :- (offeredLand(MultiPoly,Counter),Counter>=3); landOfOthers(MultiPoly).

% determine when a zone needs to be improved and for which indicator
needImprovement(IndicatorID,ZoneID) :- indicator(IndicatorID,Value,Target,ZoneLink),member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget),ZoneLink),CurrentValue<CurrentTarget.
% a zone is improved when the indicator score is higher or equal to the agent's target
improvedZone(IndicatorID,ZoneID) :- indicator(IndicatorID,Value,Target,ZoneLink),member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget),ZoneLink),CurrentValue>=CurrentTarget.

%%% Checks
% check if our agent owns a building
ownedBuilding(BuildingID) :- ourID(ID), building(BuildingID,_,ID,_,_,_,_,MultiPoly,_), MultiPoly\=multipolygon('MULTIPOLYGON EMPTY').
% budget of our Stakeholder
budget(Amount) :- stakeholder(StakeholderID,'Private_Woningbouw_Burgers',Amount,Income).
% stakeholder ID for our Stakeholder
ourID(StakeholderID) :- stakeholder(StakeholderID,'Private_Woningbouw_Burgers',Money,Income).
% stakeholder IDs for other stakeholders
notOurID(StakeholderID) :- stakeholder(StakeholderID,_,_,_),not(ourID(StakeholderID)).
% predicates to determine if land on the map is ours or others
landOfOthers(MultiPoly) :- stakeholder(StakeholderID,'Private_Woningbouw_Burgers',_,_),
	not(land(LandID,stakeholder(StakeholderID,_,_,_),MultiPoly,_,_)),
	MultiPoly\=multipolygon('MULTIPOLYGON EMPTY').
ourLand(MultiPoly) :- stakeholder(StakeholderID,'Private_Woningbouw_Burgers',_,_),
	land(LandID,stakeholder(StakeholderID,_,_,_),MultiPoly,_,_),
	MultiPoly\=multipolygon('MULTIPOLYGON EMPTY').

% uses indicator scores to determine whether more Luxury houses are desirable,if this is not the case Normal houses are desirable.  
needLuxeHouse:- indicator(34,_,_,ZoneLinkList),member(zone_link(0,_,Current1,Target1),ZoneLinkList),
	indicator(34,_,_,ZoneLinkList),member(zone_link(1,_,Current2,Target2),ZoneLinkList),
	Target1-Current1>Target2-Current2.

