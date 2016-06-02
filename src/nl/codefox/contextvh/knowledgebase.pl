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
:- dynamic upgrade_types/1.
:- dynamic indicatorLink/2.
:- dynamic indicator/4.
:- dynamic stakeholder/4.
:- dynamic zone_link/4.
:- dynamic building/8.
:- dynamic zone/5.

%%% Knowledge
:- dynamic demolished/1.
:- dynamic improvedZone/1.
:- dynamic myBuildingList/1.

% Goals that can be adopted
demolishBuilding(BuildingID) :- demolished(BuildingID).
improveZone(IndicatorID, ZoneID) :- improvedZone(IndicatorID, ZoneID).

% the ID of our agent
myStakeholderID(StakeholderID) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', Money, Income).
% the money we have in our cashstack
budget(Money) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', Money, Income).

% check if our agent owns a building
ownedBuilding(BuildingID) :- building(BuildingID,_,OwnerID,_,_,_,_,_), OwnerID = myStakeholderID(StakeholderID). 
% check if a building is ours
mine(building(_,_,myStakeholderID(StakeholderID),_,_,_,_,_)).
% generates list of all buildings that the agent owns
myBuildings(MyBuildings, List):- findall(Building, (member(Building, List), mine(Building)), Members), sort(Members, MyBuildings).

:- dynamic requestedLand/2.

% we have a building if the building list has at least 1 element.
%havebuilding :- buildings([X|Y]).

% the money we have in our cashstack
budget(X) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', X, Income).

ourID(StakeholderID) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers',_,_).

landOfOthers(MultiPoly) :- lands(List), member(land(LandID, stakeholder(OwnerID,_,_,_), MultiPoly), List), not(ourID(OwnerID)).
ourLand(MultiPoly) :- lands(List), member(land(LandID, stakeholder(OwnerID,_,_,_), MultiPoly), List), ourID(OwnerID).

doneBuying(MultiPoly) :- (requestedLand(MultiPoly, A), A >= 3) ; ourLand(MultiPoly).

% determine when a zone needs to be improved and on what aspect
needImprovement(IndicatorID, ZoneID) :- indicator(Id, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue < CurrentTarget.  
% a zone is improved when the indicator score is higher or equal to the agent's target
improvedZone(IndicatorID, ZoneID) :- indicator(Id, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue >= CurrentTarget.

