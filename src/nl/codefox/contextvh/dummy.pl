
:- dynamic stakeholders/1.
:- dynamic settings/1.
:- dynamic functions/1.
:- dynamic buildings/1.
:- dynamic zone_links/1.
:- dynamic upgrade_types/1.

% we have a building if the building list has at least 1 element.
havebuilding :- buildings([X|Y]).
