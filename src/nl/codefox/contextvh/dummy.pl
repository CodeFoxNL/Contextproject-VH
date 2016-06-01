:- dynamic stakeholders/1.
:- dynamic settings/1.
:- dynamic functions/1.
:- dynamic lands/1.
:- dynamic buildings/1.
:- dynamic requests/1.

:- dynamic offeredLand/0.
:- dynamic soldLand/0.
:- dynamic lands/1.

:- dynamic indicator/4.
:- dynamic indicatorLink/2.
:- dynamic stakeholder/4.
:- dynamic building/6.

:- dynamic zone_link/4.
:- dynamic upgrade_types/1.

% we have a building if the building list has at least 1 element.
havebuilding :- buildings([X|Y]).
