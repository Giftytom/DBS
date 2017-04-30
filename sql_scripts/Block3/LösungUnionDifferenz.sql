use employees;

-- Aufgabe 1
-- Ergänzen Sie die Liste aus Aufgabe 6 der Serie zu Projektion und Restriktion wie folgt:
-- Erstellen Sie die Liste aller Nachnamen aller männlicher Mitarbeiter, welche vor dem 1.1.1955 geboren wurden,
-- sowie aller männlichen Mitarbeiter, welche nach dem 31.12.1954 geboren wurden
-- Unterscheiden Sie die Einträge durch eine Extra-Spalte, welche entwender den Inhalt 
-- 'Männlich vor 1955 geboren' hat oder den Inhalt 'Männlich, seit 1955 geboren'
-- Sortieren Sie die Liste nach Nachnamen und innerhalb derselben Nachnamen, so dass zuerst der Text erscheint,
-- welcher die älteren Mitarbeiter betrifft.
select distinct last_name, 'Männlich vor 1955 geboren'
from employees
where gender = 'M' 
and birth_date < '1955-01-01'
union 
select distinct last_name, 'Männlich seit 1955 geboren'
from employees
where gender = 'M' 
and birth_date >= '1955-01-01'
order by 1, 2 desc;

-- Aufgabe 2
-- Erstellen Sie die Liste aller Nachnamen weiblicher Mitarbeiter, welche seit 1962 geboren wurden.
-- Ergänzen Sie die diese Liste durch alle Nachnamen männglicher Mitarbeiter, welche vor 1955 geboren wurden.
-- Sorgen Sie dafür, dass jeder Nachname nur einmal erscheint
-- Sortieren Sie die Liste alphabetisch.
select distinct last_name
from employees
where gender = 'F' and birth_date >= '1962-01-01'
union 
select distinct last_name
from employees
where gender = 'M' and birth_date < '1955-01-01'
order by 1;


-- Aufgabe 3
-- Ändern Sie das Query aus Aufgabe 3 so ab, dass die Nachnamen doppelt erscheinen,
-- Wenn es sowohl männliche, als auch weibliche Mitarbeiter aus den jeweiligen Alterskategorien gibt.
select distinct last_name
from employees
where gender = 'F' and birth_date >= '1962-01-01'
union all
select distinct last_name
from employees
where gender = 'M' and birth_date < '1955-01-01'
order by 1;

-- Aufgabe 4
-- Erstellen Sie die Liste aller Nachnamen männlicher Mitarbeiter, welche nicht auch 
-- Nachname einer Mitarbeiterin ist.
select distinct last_name
from employees
where gender = 'M'
and not last_name in (
select distinct last_name
from employees
where gender = 'F' )
order by 1;
-- Die Liste ist leer!

-- Aufgabe 5
-- Erstellen Sie die Liste aller Nachnamen männlicher Mitarbeiter, welche nicht auch 
-- Nachname einer Mitarbeiterin ist.
-- und ergänzen Sie diese Liste durch die Liste aller Nachnamen von Mitarbeiterinnen, welche
-- nicht auch Nachname eines Mitarbeiters ist.
select distinct last_name
from employees
where gender = 'M'
and not last_name in (
select distinct last_name
from employees
where gender = 'F' )
union
select distinct last_name
from employees
where gender = 'F'
and not last_name in (
select distinct last_name
from employees
where gender = 'M' )
order by 1;
-- Die Liste ist auch leer! 
-- Erinnere: Aufgabe 7 aus der Serie zu Projektion und Restriktion

-- Aufgabe 6a
-- Die Liste aller Mitarbeiternummern, Gehalt,  von und bis-Datum für welche ein Gehalt < 60000 in der Tabelle salaries erfasst ist
select emp_no, salary, from_date, to_date 
from salaries 
where salary < 60000;

-- Aufgabe 6b
-- Wir nehmen an, dass das Datum '9999-01-01' bedeuten soll, dass der Mitarbeiter aktuell in dieses Gehalt bezieht
-- (Man hätte hier auch mit NULL arbeiten können - statt auf NULL abzufragen, müssen wir jetzt immer auf 9999-01-01 abfragen)
-- Ergänzen Sie die Abfrage aus 6a so, dass nur diejenigen Mitarbeiternummer ausgegebn werden, für welche das
-- aktuelle Gehalt < 60000 ist
select emp_no, salary, from_date, to_date 
from salaries 
where salary < 60000 and to_date = '9999-01-01';

-- Aufgabe 6c
-- Erstellen Sie die Liste aller Miarbeiternummern, von und bis-datum, welche als Manager eines Department erfasst sind
-- Tabelle dept_manager
-- Berücksichtigen Sie nur die aktullen Manager  - Abfrage auf das Datum 9999-01-01
select emp_no,  from_date, to_date 
from dept_manager
where to_date = '9999-01-01';

-- Aufgabe 6d
-- Erstellen Sie die Liste aller aktuellen Abteilungsleiter (6c), welche weniger verdienen als 60000 (6b)
-- Bilden Sie dazu die Differenz
-- Wie beurteilen Sie das Ergebnis?
select emp_no,  from_date, to_date 
from dept_manager
where to_date = '9999-01-01'
and not emp_no in
(
select emp_no
from salaries 
where salary < 60000 and to_date = '9999-01-01'
);
-- Beurteilung des Ergebnisses: Betrachtet man alle Teilergebnisse aus Aufgabe 6
-- dann stellt man massive Inkonsistenzen in den Daten fest.






