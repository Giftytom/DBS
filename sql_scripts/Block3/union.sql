use inventar;

select 'Kleiner 5', bezeichnung, id from geraetetyp where id < 5
union
select 'Grösser 5', bezeichnung, id  from geraetetyp where id > 5
union 
select 'Gleich 5', bezeichnung, id  from geraetetyp where id = 5
order by 1;


select 'Kleiner 5', bezeichnung, id from geraetetyp where id < 5
union
select 'Grösser 5', bezeichnung, id  from geraetetyp where id > 5
union 
select null , bezeichnung, id  from geraetetyp where id = 5
order by 1;


-- union all - um Duplikate im Ergebnis zu zeigen
select standort_id from geraet
union all
select id from standort;


-- select distinct - um aus Queries ohne Union die Duplikate aus dem Ergebnis zu entfernen
select distinct standort_id from geraet;

-- OR reformuliert als UNION
select id, bezeichnung from geraetetyp where id < 5 or id > 5;

select id, bezeichnung from geraetetyp where id < 5 
union
select id, bezeichnung from geraetetyp where id > 5;



