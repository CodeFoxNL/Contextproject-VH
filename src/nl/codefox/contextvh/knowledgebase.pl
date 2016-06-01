%%% Percepts that the agent receives from the environment
:- dynamic offeredLand/0.
:- dynamic soldLand/0.

:- dynamic stakeholders/1.
:- dynamic settings/1.
:- dynamic functions/1.
:- dynamic indicators/1.
:- dynamic buildings/1.
:- dynamic upgrade_types/1.
:- dynamic lands/1.
:- dynamic zones/1.
:- dynamic zone_links/1.
:- dynamic requests/1.

:- dynamic indicatorLink/2.
:- dynamic indicator/4.
:- dynamic stakeholder/4.
:- dynamic building/7.
:- dynamic zone_link/4.
:- dynamic zone/5.


%%% Percepts for indicators that the agent uses
% check with metrics what our agent needs (!)
% .....

%%% Knowledge
% wanneer is iets gesloopt, gebouwd, gekocht, lege grond
:- dynamic demolished/1.
% constructed, planned, bid

% demolish a building
demolishBuilding(ID) :- demolished(ID).

% we have a building if the building list has at least 1 element.
havebuilding :- buildings([X|Y]).

% the money we have in our cashstack
budget(X) :- stakeholder(StakeholderID, 'Private_Woningbouw_Burgers', X, Income).


needImprovement(IndicatorID, ZoneID) :- indicator(Id, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue < CurrentTarget.  
improvedZone(IndicatorID, ZoneID) :- indicator(Id, Value, Target, ZoneLink), member(zone_link(ZoneID,IndicatorID,CurrentValue,CurrentTarget), ZoneLink), CurrentValue >= CurrentTarget.

