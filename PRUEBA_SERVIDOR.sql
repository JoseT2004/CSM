-- Opcional: ejecutar DESPUÉS de setup.sql, en SQL Editor. Todo se revierte.
-- Verifica lógica básica del servidor sin abrir cuatro dispositivos.
begin;
do $$
declare s jsonb; q jsonb; a jsonb; codes text; tokens text[]:='{}'; picks int; i int; j int; epoch int; selected jsonb; votes jsonb; total int; own_id text; caught boolean; old_hand jsonb;
begin
 s:=public.csm_game('create','','','{"nick":"TEST A","rounds":1}'::jsonb);
 codes:=s->>'code'; tokens:=array_append(tokens,s->>'token');
 for i in 2..4 loop
   s:=public.csm_game('join',codes,'',jsonb_build_object('nick','TEST '||i)); tokens:=array_append(tokens,s->>'token');
 end loop;
 s:=public.csm_game('start',codes,tokens[1],'{"rounds":1}'::jsonb);
 if s->>'phase'<>'pick' or jsonb_array_length(s->'hand')<>10 then raise exception 'Fallo: inicio'; end if;
 epoch:=(s->>'epoch')::int; picks:=(s->'question'->>'picks')::int;
 -- Prueba de cambios 2+1, límite y reposición.
 old_hand:=s->'hand';
 select jsonb_agg(x->'id') into selected from (select value as x from jsonb_array_elements(old_hand) limit 2) sub;
 s:=public.csm_game('swap',codes,tokens[1],jsonb_build_object('epoch',epoch,'cards',selected));
 if (s->>'swapsLeft')::int<>1 or jsonb_array_length(s->'hand')<>10 or exists(select 1 from jsonb_array_elements(s->'hand') x where selected @> jsonb_build_array(x->'id')) then raise exception 'Fallo: cambio de 2 cartas'; end if;
 selected:=jsonb_build_array(s->'hand'->0->'id');
 s:=public.csm_game('swap',codes,tokens[1],jsonb_build_object('epoch',epoch,'cards',selected));
 if (s->>'swapsLeft')::int<>0 or jsonb_array_length(s->'hand')<>10 then raise exception 'Fallo: tercer cambio'; end if;
 caught:=false;
 begin perform public.csm_game('swap',codes,tokens[1],jsonb_build_object('epoch',epoch,'cards',jsonb_build_array(s->'hand'->0->'id'))); exception when others then caught:=true; end;
 if not caught then raise exception 'Fallo: cuarto cambio aceptado'; end if;
 for i in 1..4 loop
   s:=public.csm_game('state',codes,tokens[i]);
   select jsonb_agg(x->'id') into selected from (select value as x from jsonb_array_elements(s->'hand') limit picks) sub;
   s:=public.csm_game('submit',codes,tokens[i],jsonb_build_object('epoch',epoch,'cards',selected));
   if i<4 and (s->>'phase'<>'pick' or jsonb_array_length(s->'answers')<>0) then raise exception 'Fallo: privacidad en selección'; end if;
 end loop;
 for j in 1..4 loop
   s:=public.csm_game('state',codes,tokens[1]); epoch:=(s->>'epoch')::int;
   if s->>'phase'<>'reveal' or (s->>'reveal')::int<>j or jsonb_array_length(s->'answers')<>1 or (s->'answers'->0) ? 'author' then raise exception 'Fallo: revelación'; end if;
   for i in 1..4 loop
     s:=public.csm_game('ack',codes,tokens[i],jsonb_build_object('epoch',epoch));
     if i<4 and (s->>'reveal')::int<>j then raise exception 'Fallo: barrera de confirmación'; end if;
   end loop;
 end loop;
 if s->>'phase'<>'vote' then raise exception 'Fallo: no inició voto'; end if;
 epoch:=(s->>'epoch')::int;
 for i in 1..4 loop
   s:=public.csm_game('state',codes,tokens[i]);
   select jsonb_agg(x->'id') into votes from (select value as x from jsonb_array_elements(s->'answers') where not (value->>'own')::boolean limit 2) sub;
   select value->>'id' into own_id from jsonb_array_elements(s->'answers') where (value->>'own')::boolean;
   if i=1 then
     caught:=false;
     begin perform public.csm_game('vote',codes,tokens[i],jsonb_build_object('epoch',epoch,'first',own_id,'second',votes->>0)); exception when others then caught:=true; end;
     if not caught then raise exception 'Fallo: voto propio aceptado'; end if;
   end if;
   s:=public.csm_game('vote',codes,tokens[i],jsonb_build_object('epoch',epoch,'first',case when i=1 then null else votes->>0 end,'second',case when i<=2 then null else votes->>1 end));
   if i<4 and (s->>'phase'<>'vote' or (s->'answers'->0) ? 'points') then raise exception 'Fallo: votos prematuros'; end if;
 end loop;
 select sum((value->>'score')::int) into total from jsonb_array_elements(s->'players');
 if s->>'phase'<>'results' or total<>8 then raise exception 'Fallo: puntuación %',total; end if;
 epoch:=(s->>'epoch')::int;
 for i in 1..4 loop s:=public.csm_game('ack',codes,tokens[i],jsonb_build_object('epoch',epoch)); end loop;
 if s->>'phase'<>'finished' then raise exception 'Fallo: final'; end if;
 raise notice 'CSM: PRUEBA OK — privacidad, barrera, cambios, votos opcionales y 8 puntos.';
end $$;
rollback;
