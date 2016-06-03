%%% Percepts that the agent receives from the environment
:- dynamic stakeholders/1.
:- dynamic settings/1.
:- dynamic functions/1.
:- dynamic indicators/1.
:- dynamic buildings/1.
:- dynamic lands/1.
:- dynamic zones/1.
:- dynamic zone_links/1.
:- dynamic requests/1.
:- dynamic actions/1.

% others
:- dynamic offeredLand/0.
:- dynamic soldLand/0.
:- dynamic upgrade_type/3.
:- dynamic indicatorLink/2.
:- dynamic indicator/4.
:- dynamic stakeholder/4.
:- dynamic zone_link/4.
:- dynamic building/8.
:- dynamic zone/5.
:- dynamic actionlog/4.

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
doneBuying(MultiPoly) :- (requestedLand(MultiPoly, A), A >= 3) ; ourLand(MultiPoly).
doneSelling(MultiPoly) :- (offeredLand(MultiPoly, A), A >= 3); landOfOthers(MultiPoly).

% we have a building if the building list has at least 1 element.
%havebuilding :- buildings([X|Y]).

% check if our agent owns a building
ownedBuilding(BuildingID) :- building(BuildingID,_,OwnerID,_,_,_,_,_), stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', Money, Income), StakeholderID = OwnerID. 
% check if a building is ours
mine(building(_,_,myStakeholderID(StakeholderID),_,_,_,_,_)).
% generates list of all buildings that the agent owns
myBuildings(MyBuildings, List):- findall(Building, (member(Building, List), mine(Building)), Members), sort(Members, MyBuildings).

% predicates for information about our stakeholder: budget and ID
budget(X) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', X, Income).
ourID(StakeholderID) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', Money, Income).
notOurID(StakeholderID) :- stakeholder(StakeholderID, _, _, _), not(ourID(StakeholderID)).

% predicates to determine if land on the map is ours or others
landOfOthers(MultiPoly) :- lands(List),stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', _, _), not(member(land(LandID, stakeholder(StakeholderID,_,_,_), MultiPoly), List)), MultiPoly \= multipolygon('MULTIPOLYGON EMPTY').
ourLand(MultiPoly) :- lands(List),stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', _, _), member(land(LandID, stakeholder(StakeholderID,_,_,_), MultiPoly), List), MultiPoly \= multipolygon('MULTIPOLYGON EMPTY').

% determine when a zone needs to be improved and on what aspect
needImprovement(IndicatorID, ZoneID) :- indicator(Id, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue < CurrentTarget.  
% a zone is improved when the indicator score is higher or equal to the agent's target
improvedZone(IndicatorID, ZoneID) :- indicator(Id, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue >= CurrentTarget.

