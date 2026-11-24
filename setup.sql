-- CSM | Ejecuta una vez en un proyecto Supabase dedicado.
begin;
create schema if not exists csm;
revoke all on schema csm from public, anon, authenticated;
create table if not exists csm.cards(kind text not null check(kind in ('b','w')), id int not null, body text not null, picks int not null default 1, primary key(kind,id));
create table if not exists csm.rooms(code text primary key, host uuid, phase text not null default 'lobby', round_no int not null default 0, rounds int not null default 10, black_id int, black_deck int[] not null default '{}', white_deck int[] not null default '{}', reveal_no int not null default 0, epoch int not null default 0, updated_at timestamptz not null default now());
create table if not exists csm.players(id uuid primary key default gen_random_uuid(), token uuid unique not null default gen_random_uuid(), room text not null references csm.rooms(code) on delete cascade, nick text not null, seat int not null, score int not null default 0, hand int[] not null default '{}', ack boolean not null default false, unique(room,seat));
create table if not exists csm.answers(id uuid primary key default gen_random_uuid(), room text not null references csm.rooms(code) on delete cascade, player uuid unique not null references csm.players(id) on delete cascade, cards int[] not null, pos int, points int not null default 0);
create table if not exists csm.votes(player uuid primary key references csm.players(id) on delete cascade, room text not null references csm.rooms(code) on delete cascade, first_id uuid not null references csm.answers(id) on delete cascade, second_id uuid not null references csm.answers(id) on delete cascade);
-- Migración compatible con v1.0; ejecutar sin partidas activas.
alter table csm.votes alter column first_id drop not null;
alter table csm.votes alter column second_id drop not null;
alter table csm.players add column if not exists swapped_ids int[] not null default '{}';
create index if not exists csm_players_room on csm.players(room);
create index if not exists csm_answers_room on csm.answers(room);
create index if not exists csm_votes_room on csm.votes(room);
revoke all on all tables in schema csm from public, anon, authenticated;
insert into csm.cards(kind,id,body,picks) values
('b',1,'¿Qué encontró Magaly en el celular de mi viejo?',1),
('b',2,'El Perú tiene tres regiones naturales: costa, sierra y ___.',1),
('b',3,'¿Qué chucha están vendiendo ahora en el Avelino?',1),
('b',4,'Mi mamá prendió una velita para que Dios me libre de ___.',1),
('b',5,'La verdadera razón por la que Bolognesi no se rindió: ___.',1),
('b',6,'No me da vergüenza admitir que me gusta ___.',1),
('b',7,'¿Qué hay en la mochila de {derecha}?',1),
('b',8,'El nuevo sabor de Inca Kola: ___.',1),
('b',9,'Mi primera vez olía a ___.',1),
('b',10,'¿Qué se necesita para ser presidente del Perú?',1),
('b',11,'Se suspendieron las clases en la UNSA debido a ___.',1),
('b',12,'Lo que pasa en Camaná se queda en Camaná. Excepto ___.',1),
('b',13,'Mi abuelita murió sin saber qué era ___.',1),
('b',14,'No importa cuánta plata tengas, jamás podrás comprar ___.',1),
('b',15,'La última búsqueda de Google de mi papá fue ___.',1),
('b',16,'Al fondo hay sitio, pero también hay ___.',1),
('b',17,'¿Qué debería ser considerado patrimonio cultural del Perú?',1),
('b',18,'El profe dijo que podíamos llevar cualquier material al examen. Yo llevé ___.',1),
('b',19,'Paucarpata: tierra de ___.',1),
('b',20,'¿Qué está escondiendo la Iglesia desde hace siglos?',1),
('b',21,'Mi mamá encontró ___ debajo de mi cama.',1),
('b',22,'¿Qué es lo peor que te pueden decir mientras estás cagando?',1),
('b',23,'La única razón por la que todavía no tengo hijos es ___.',1),
('b',24,'Si alguna vez me ves llorando, probablemente sea por ___.',1),
('b',25,'¿Qué tiene mi ex que no tenga yo?',1),
('b',26,'Asu Mare 4: ___.',1),
('b',27,'Gracias, Señor, por los alimentos y por ___.',1),
('b',28,'¿Con qué me van a recibir en el infierno?',1),
('b',29,'Mi papá me enseñó a manejar, a tomar cerveza y a apreciar ___.',1),
('b',30,'{izquierda} vendería su culo a cambio de ___.',1),
('b',31,'¿Qué le falta a la Plaza de Armas para ser perfecta?',1),
('b',32,'El SIS acaba de aprobar un tratamiento para ___.',1),
('b',33,'El próximo curso obligatorio de Estudios Generales será ___.',1),
('b',34,'No lo van a creer, pero la momia Juanita murió por ___.',1),
('b',35,'¿Qué me recomienda el algoritmo de TikTok a las tres de la mañana?',1),
('b',36,'Lo único que me mantiene con vida durante finales es ___.',1),
('b',37,'¿Qué hay en la maleta que nadie quiere recoger en el Terminal Terrestre?',1),
('b',38,'Mi mamá dice que me enfermé por ___.',1),
('b',39,'El Misti no está inactivo. Está esperando ___.',1),
('b',40,'En lugar de bailar el vals, en mi boda habrá ___.',1),
('b',41,'El verdadero motivo por el que mi papá salió a comprar pan: ___.',1),
('b',42,'¿Qué pidió {mesa} para Navidad?',1),
('b',43,'Señores pasajeros, por favor absténganse de ___.',1),
('b',44,'¿Qué es lo primero que haría si ganara la Tinka?',1),
('b',45,'No hay nada más peruano que ___.',1),
('b',46,'El secreto para llegar a los 100 años es ___.',1),
('b',47,'¿Qué no debería llevar al velorio de mi suegra?',1),
('b',48,'¿Qué hay realmente en los tuppers que nunca devolví?',1),
('b',49,'Mi último mensaje antes de que me bloqueara decía: «___».',1),
('b',50,'El nuevo requisito para sacar brevete es ___.',1),
('b',51,'La contraseña del wifi de mi abuelita es ___.',1),
('b',52,'¿Qué encontró el arqueólogo dentro de una chullpa?',1),
('b',53,'Me quedé sin Beca 18 por culpa de ___.',1),
('b',54,'Mi pequeño negocio de ___ quebró a los dos días.',1),
('b',55,'¿Qué le faltó a mi educación sexual?',1),
('b',56,'El menú ejecutivo de hoy incluye ___.',1),
('b',57,'Mi psicólogo me cobra 80 soles para hablar de ___.',1),
('b',58,'¿Qué está vendiendo {mesa} por Marketplace?',1),
('b',59,'Lo último que quiero oír durante un temblor es ___.',1),
('b',60,'Los extraterrestres vinieron al Perú buscando ___.',1),
('b',61,'¿Qué lleva un peruano en la maleta cuando se va a vivir al extranjero?',1),
('b',62,'En esta casa se respeta a Dios, a tu madre y a ___.',1),
('b',63,'Se busca personal con experiencia en ___. Sueldo mínimo.',1),
('b',64,'La universidad me dio un diploma por ___.',1),
('b',65,'¿Qué puso {derecha} en su descripción de Tinder?',1),
('b',66,'Mi relación a distancia terminó por ___.',1),
('b',67,'¿Qué le pediría a un genio si me quedara un solo deseo?',1),
('b',68,'La última frase de mi abuelo antes de morir fue: «___».',1),
('b',69,'El nuevo monumento de Cerro Colorado será dedicado a ___.',1),
('b',70,'¿Qué fue lo que realmente se llevaron los Reyes Magos?',1),
('b',71,'Mi cura me mandó a rezar tres padrenuestros por ___.',1),
('b',72,'La razón por la que no me dejan volver a esa picantería: ___.',1),
('b',73,'¿Qué le escondería al médico durante un chequeo?',1),
('b',74,'Los incas ya habían inventado ___ antes de que llegaran los españoles.',1),
('b',75,'¿Qué hace {izquierda} cuando nadie lo está viendo?',1),
('b',76,'Mi jefe dice que no hay presupuesto para aumentos, pero sí para ___.',1),
('b',77,'¿Con qué me confundieron en el hospital?',1),
('b',78,'El próximo feriado nacional será en honor a ___.',1),
('b',79,'Lo más raro que he visto desde la ventana de una combi: ___.',1),
('b',80,'Hoy no fui a clases porque tenía una cita con ___.',1),
('b',81,'¿Qué hará que me echen de la casa?',1),
('b',82,'El nuevo deporte de los Juegos Olímpicos: ___.',1),
('b',83,'Mi familia decidió dejar de hablarme por ___.',1),
('b',84,'¿Qué hay detrás de la puerta prohibida de la UNSA?',1),
('b',85,'El último audio que mandó {mesa} al grupo familiar trataba sobre ___.',1),
('b',86,'En el colegio me enseñaron que ___ era pecado, pero que ___ estaba bien.',2),
('b',87,'Hoy en Magaly TV: imágenes exclusivas de ___ con ___.',2),
('b',88,'Mi tesis se titula: Influencia de ___ sobre ___ en Arequipa.',2),
('b',89,'Mi primera experiencia sexual involucró ___ y ___.',2),
('b',90,'Mi ex tuvo que elegir entre ___ y ___.',2),
('b',91,'Antes de morir quiero experimentar ___. Después de morir, ___.',2),
('b',92,'Mi mamá me dio ___. Mi papá, en cambio, me dio ___.',2),
('b',93,'Este 28 de julio celebramos dos grandes logros del Perú: ___ y ___.',2),
('b',94,'El nuevo menú universitario incluye ___ con una porción de ___.',2),
('b',95,'Se vende ___. Se acepta ___ como medio de pago.',2),
('b',96,'El nuevo éxito de Netflix: ___ contra ___.',2),
('b',97,'Hay dos cosas que no se prestan: ___ y ___.',2),
('b',98,'La Iglesia ahora acepta ___, pero todavía condena ___.',2),
('b',99,'Mi CV dice que tengo experiencia en ___ y un diplomado en ___.',2),
('b',100,'Mi vecino llamó a Serenazgo porque confundió ___ con ___.',2),
('w',1,'Tu vieja',1),
('w',2,'Una orgía patrocinada por Caja Arequipa',1),
('w',3,'La diarrea',1),
('w',4,'Un choro con principios',1),
('w',5,'La pastilla del día siguiente',1),
('w',6,'Los huevos de Miguel Grau',1),
('w',7,'Una borrachera financiada por Beca 18',1),
('w',8,'Un emolientero que también vende agua bendita',1),
('w',9,'Un calato en el centro de Arequipa',1),
('w',10,'La impotencia sexual',1),
('w',11,'Una cachimbada que acabó en la comisaría',1),
('w',12,'Un Yape falso',1),
('w',13,'La segunda venida de Cristo',1),
('w',14,'Un calzoncillo que ya se puede parar solo',1),
('w',15,'Mi papá y su otra familia',1),
('w',16,'La pobreza extrema',1),
('w',17,'Un cuy atropellado',1),
('w',18,'El hijo que sí salió del matrimonio',1),
('w',19,'Una erección en el momento menos indicado',1),
('w',20,'Los baños del Avelino',1),
('w',21,'La eutanasia',1),
('w',22,'SIDA',1),
('w',23,'Un condón vencido',1),
('w',24,'El cadáver de mi sugar daddy',1),
('w',25,'Un menú de siete soles que incluye purgante',1),
('w',26,'Cagarse en plena exposición',1),
('w',27,'Un ingeniero titulado por Facebook Marketplace',1),
('w',28,'La menstruación',1),
('w',29,'La momia Juanita',1),
('w',30,'Un feto con DNI',1),
('w',31,'Los testigos de Jehová',1),
('w',32,'Una teta más grande que la otra',1),
('w',33,'Una invasión de terreno en el cielo',1),
('w',34,'El retiro de mi AFP',1),
('w',35,'Una prostituta que acepta Yape',1),
('w',36,'{derecha}',1),
('w',37,'El olor a culo',1),
('w',38,'Combustión anal espontánea',1),
('w',39,'La educación sexual de mis padres',1),
('w',40,'Una rata del tamaño de un gato',1),
('w',41,'El pene de un desconocido',1),
('w',42,'Un certificado médico comprado',1),
('w',43,'Los 30 segundos más decepcionantes de mi vida',1),
('w',44,'Una chocolatada con presupuesto de obra pública',1),
('w',45,'La calvicie de mi culo',1),
('w',46,'La SUNAT',1),
('w',47,'La parte más venosa del nepe',1),
('w',48,'La muerte de mi mascota',1),
('w',49,'Un mototaxista con doctorado',1),
('w',50,'Los universitarios más pendejos de Arequipa',1),
('w',51,'Un huevo que necesita atención médica',1),
('w',52,'Un aborto clandestino',1),
('w',53,'Lord Farquaad',1),
('w',54,'Un bautizo en la piscina de un telo',1),
('w',55,'Mi compañero de grupo que no hizo ni mierda',1),
('w',56,'El tercer pezón',1),
('w',57,'Una pollada para pagar la pensión de alimentos',1),
('w',58,'Un viejo verde',1),
('w',59,'La pensión alimenticia de mi sugar daddy',1),
('w',60,'El Niño Dios',1),
('w',61,'Una foto de mi ex en pelotas',1),
('w',62,'Un ataúd de segunda mano',1),
('w',63,'Un caldo de órganos no identificados',1),
('w',64,'La hepatitis',1),
('w',65,'Una mamada por responsabilidad social',1),
('w',66,'El desagüe del río Chili',1),
('w',67,'Un frasco de prepucios',1),
('w',68,'Un tío que pide perdón en el grupo familiar a las tres de la mañana',1),
('w',69,'Los restos de mi dignidad',1),
('w',70,'Una vaca con depresión',1),
('w',71,'Un tampón usado',1),
('w',72,'La última neurona de un congresista',1),
('w',73,'Una flatulencia con denominación de origen',1),
('w',74,'Un trío que terminó en denuncia',1),
('w',75,'Un padre ausente',1),
('w',76,'Un pollo a la brasa con las cenizas de mi abuelo',1),
('w',77,'Un vibrador comprado en el Avelino',1),
('w',78,'La flacidez de mis nalgas',1),
('w',79,'Un condenado a muerte',1),
('w',80,'Mi historial de búsqueda',1),
('w',81,'Una pollada para pagar la vasectomía',1),
('w',82,'Mi ano después de comer rocoto',1),
('w',83,'Mi moco seco',1),
('w',84,'Un temblor provocado por mi suegra',1),
('w',85,'Un cura con Tinder Premium',1),
('w',86,'Los huacos eróticos',1),
('w',87,'Una colecta para pagar el OnlyFans de mi profesor',1),
('w',88,'Un DNI encontrado en el motel',1),
('w',89,'El ano de un pan francés',1),
('w',90,'Un borracho que insiste en manejar',1),
('w',91,'El semen',1),
('w',92,'Una prueba de ADN en Navidad',1),
('w',93,'Una estafa piramidal de agua bendita',1),
('w',94,'El sonido de un pedo en un funeral',1),
('w',95,'Una visita inesperada de la SUNAT',1),
('w',96,'Un funeral con hora loca',1),
('w',97,'Un kilo de grasa de liposucción',1),
('w',98,'La próstata',1),
('w',99,'La última voluntad de un cachudo',1),
('w',100,'La ex que me debe una prueba de paternidad',1),
('w',101,'El Avelino a mediodía',1),
('w',102,'Un bebé con cara de viejo',1),
('w',103,'Un olor a muerto que nadie sabe de dónde viene',1),
('w',104,'Una cola de gente esperando su turno para pecar',1),
('w',105,'Una deuda con la mafia del bingo parroquial',1),
('w',106,'Mi pinche suerte',1),
('w',107,'La caspa',1),
('w',108,'Un chupetón en la foto del DNI',1),
('w',109,'Un aborto de tesis',1),
('w',110,'{izquierda}',1),
('w',111,'Una boda entre dos personas que se odian',1),
('w',112,'Un préstamo para pagar mi cambio de sexo',1),
('w',113,'Un caldo de cabeza sin preguntar de quién',1),
('w',114,'La sobrina favorita de mi tío',1),
('w',115,'Una tesis sobre la masturbación en época de parciales',1),
('w',116,'Un anticucho de procedencia humana',1),
('w',117,'Los dientes postizos de mi abuela',1),
('w',118,'La disfunción eréctil',1),
('w',119,'Una toalla con antecedentes penales',1),
('w',120,'Pedir fiado en un prostíbulo',1),
('w',121,'La virginidad de un estudiante de Sistemas',1),
('w',122,'Una resurrección con resaca',1),
('w',123,'El agua del baño de un telo',1),
('w',124,'Un cobrador de combi con tres familias',1),
('w',125,'Dormir desnudo en casa de mi suegra',1),
('w',126,'Un supositorio',1),
('w',127,'La caca de paloma',1),
('w',128,'Una prueba de embarazo positiva',1),
('w',129,'La cárcel',1),
('w',130,'Un audio de mi papá confesando un delito',1),
('w',131,'Una beca de estudios para mi amante',1),
('w',132,'Una herencia de veinte soles',1),
('w',133,'Una verruga en el culo',1),
('w',134,'Un crucifijo confiscado por la policía',1),
('w',135,'Un óvulo a cinco soles',1),
('w',136,'Un gringo que aprendió a decir conchatumadre',1),
('w',137,'Mi padrastro de 23 años',1),
('w',138,'Una mentira en el lecho de muerte',1),
('w',139,'El candidato que regala táperes',1),
('w',140,'Un maniquí con orden de alejamiento',1),
('w',141,'La leche de un varón decepcionado',1),
('w',142,'La cuenta del telo',1),
('w',143,'Papel higiénico de segunda mano',1),
('w',144,'El olor a pata',1),
('w',145,'Una piñata rellena de pruebas de embarazo',1),
('w',146,'El tráfico de órganos por catálogo',1),
('w',147,'Un chancho que se cree el Mesías',1),
('w',148,'Un embargo de juguetes para adultos',1),
('w',149,'Un gemido que atravesó tres paredes',1),
('w',150,'La tercera edad',1),
('w',151,'Una peluca hecha de pelos del poto',1),
('w',152,'Un pedo silencioso',1),
('w',153,'La cara de mi mamá al ver mis notas',1),
('w',154,'Una herencia disputada antes del funeral',1),
('w',155,'Un tío que cura la sífilis con manzanilla',1),
('w',156,'Un examen de próstata',1),
('w',157,'Un préstamo del gota a gota',1),
('w',158,'Un queso helado con sabor a culpa',1),
('w',159,'La zona de fumadores del infierno',1),
('w',160,'Un entierro por delivery',1),
('w',161,'Un recibo por servicios sexuales',1),
('w',162,'Un novio prestado',1),
('w',163,'La ropa interior de la semana pasada',1),
('w',164,'El herpes',1),
('w',165,'Un taxi que huele a infidelidad',1),
('w',166,'La promoción de dos por uno en el telo',1),
('w',167,'Un mapache con mi DNI',1),
('w',168,'El historial de un cibercafé abandonado',1),
('w',169,'Una entrevista de trabajo en calzoncillos',1),
('w',170,'Una bolsa de testículos de utilería',1),
('w',171,'El chiste que contó el cura',1),
('w',172,'Una gallina con chaleco de la UNSA',1),
('w',173,'La alfombra de un prostíbulo',1),
('w',174,'Un padrino con orden de captura',1),
('w',175,'Una foto familiar con los tres amantes de mi mamá',1),
('w',176,'Un testículo',1),
('w',177,'El ruido sospechoso de un baño público',1),
('w',178,'La abstinencia',1),
('w',179,'Una microdosis de dignidad',1),
('w',180,'Un choclo en una radiografía',1),
('w',181,'Una transferencia bancaria a mi extorsionador',1),
('w',182,'Un táper lleno de cenizas humanas',1),
('w',183,'Mi mamá rezando para que no salga la prueba de ADN',1),
('w',184,'Una vasectomía en oferta',1),
('w',185,'Un profesor que dicta clases desde el penal',1),
('w',186,'Un pollo sin patas',1),
('w',187,'El trauma de mi psicólogo',1),
('w',188,'Una tía que pregunta por mi fertilidad en el velorio',1),
('w',189,'Una rascadita de poto',1),
('w',190,'Una caja llena de uñas cortadas',1),
('w',191,'Un entierro con chancho al cilindro',1),
('w',192,'Una rifa para pagar el funeral del organizador',1),
('w',193,'Un sacerdote ateo',1),
('w',194,'Un sol de saldo y tres órdenes de captura',1),
('w',195,'La herencia del amante de mi abuela',1),
('w',196,'El espíritu de Túpac Amaru',1),
('w',197,'Un chupetín con pelos',1),
('w',198,'Un jubilado adicto al casino',1),
('w',199,'Una quema ritual de ropa interior',1),
('w',200,'Una tortuga con ansiedad',1),
('w',201,'El cáncer de colon',1),
('w',202,'Una misa de cuerpo presente sin cuerpo',1),
('w',203,'El sacachispas de mi viejo',1),
('w',204,'La teta izquierda',1),
('w',205,'Un PowerPoint de la autopsia',1),
('w',206,'Una bolsa de sangre con fecha vencida',1),
('w',207,'El colchón de mis papás',1),
('w',208,'Un curso de cómo ser un sugar baby exitoso',1),
('w',209,'Un caldo de gallina para recuperarse de una orgía',1),
('w',210,'Una multa por exhibicionismo',1),
('w',211,'Un choro que devuelve la billetera sin plata',1),
('w',212,'La Virgen de Chapi',1),
('w',213,'Los venezolanos y peruanos peleándose por la receta de la arepa',1),
('w',214,'Un culo de botella',1),
('w',215,'Un huevo que no era de gallina',1),
('w',216,'Mi ex y su nuevo novio',1),
('w',217,'Un billete de veinte encontrado en un calzoncillo',1),
('w',218,'Un sticker obsceno en el grupo de la familia',1),
('w',219,'Tres mariachis en el entierro equivocado',1),
('w',220,'Un queso que desarrolló conciencia propia',1),
('w',221,'La depilación con cinta de embalaje',1),
('w',222,'Los pelos del ombligo',1),
('w',223,'Una reunión de Zoom sin pantalón',1),
('w',224,'Una prueba de polígrafo en la luna de miel',1),
('w',225,'Un velorio con canje de puntos',1),
('w',226,'Los hongos de mis pies',1),
('w',227,'La última cena de un condenado a muerte',1),
('w',228,'Un cuarto de alquiler con un fantasma voyeur',1),
('w',229,'El baño de una discoteca',1),
('w',230,'Una chicha de jora fermentada en un calzón',1),
('w',231,'Un chifa clandestino dentro de un cementerio',1),
('w',232,'El ex de mi pareja en mi árbol genealógico',1),
('w',233,'La lista de hijos no reconocidos de mi papá',1),
('w',234,'La resaca del lunes',1),
('w',235,'Un culito sudado',1),
('w',236,'Una foto con el esqueleto de Anatomía',1),
('w',237,'La contraseña del OnlyFans de mi vecino',1),
('w',238,'El Misti haciendo erupción en época de parciales',1),
('w',239,'Un piercing donde no llega el sol',1),
('w',240,'Un congresista con secundaria completa',1),
('w',241,'Un sorbo de formol',1),
('w',242,'Una factura de la morgue',1),
('w',243,'Una llamada de cobranza en plena misa',1),
('w',244,'El tío que comparte Piolines de buenos días',1),
('w',245,'Una cita para la autopsia dentro de seis meses',1),
('w',246,'Mi vieja gritándome desde el primer piso',1),
('w',247,'Un chocolatito laxante en Navidad',1),
('w',248,'La marca del calzoncillo en la piel',1),
('w',249,'Un bombero que se excita con las alarmas',1),
('w',250,'Un certificado de virginidad emitido por la SUNAT',1),
('w',251,'Una bolsa de vómito con sorpresa',1),
('w',252,'Una beca para estudiar cómo ser mantenido',1),
('w',253,'Los huevos de Gokú',1),
('w',254,'Un soltero de cuarenta con toque de queda',1),
('w',255,'Mi primer sueldo en un club nocturno',1),
('w',256,'Un pelo púbico entre los dientes',1),
('w',257,'Una suegra que sabe demasiado',1),
('w',258,'Un cuarto con paredes de triplay',1),
('w',259,'Un fantasma que no acepta que ya murió',1),
('w',260,'Un profesor que toma asistencia en el velorio',1),
('w',261,'Una oferta laboral de esclavitud emocional',1),
('w',262,'Un olor que no sale con jabón',1),
('w',263,'Un cuy con implantes de silicona',1),
('w',264,'Un bingo para financiar el divorcio del cura',1),
('w',265,'Los mocos de mi primo',1),
('w',266,'Un tío que llegó borracho a su propia operación',1),
('w',267,'Un silbato atorado en el culo',1),
('w',268,'Una denuncia por ruido en el telo',1),
('w',269,'La tuberculosis',1),
('w',270,'El apocalipsis',1),
('w',271,'Un calato con solo una media',1),
('w',272,'El gel íntimo',1),
('w',273,'Un rosario fluorescente',1),
('w',274,'Un perro que heredó toda la fortuna familiar',1),
('w',275,'El Santo Sudario',1),
('w',276,'La vecina que escucha detrás de la puerta',1),
('w',277,'Mi último espermatozoide viable',1),
('w',278,'Una jarra de agua de la morgue',1),
('w',279,'Un pene dibujado en la carpeta',1),
('w',280,'Un contrato prenupcial escrito en papel higiénico',1),
('w',281,'Una boda sin novia',1),
('w',282,'Una procesión de santos borrachos',1),
('w',283,'La caquita del cuy',1),
('w',284,'Un saco de calzones decomisados',1),
('w',285,'El tío que vende su voto por un polo',1),
('w',286,'La foto que no debí subir a estados',1),
('w',287,'Un condón relleno de agua',1),
('w',288,'Una rifa cuyo premio es un ataúd',1),
('w',289,'Una cucharada de fluidos misteriosos',1),
('w',290,'Un himno nacional cantado en un telo',1),
('w',291,'Un baño compartido por seis cachudos',1),
('w',292,'Una tarjeta de cumpleaños de la funeraria',1),
('w',293,'El hermano que vendió las cenizas de mi abuelo',1),
('w',294,'Una nalga quemada en Camaná',1),
('w',295,'Un funeral auspiciado por una pollería',1),
('w',296,'Un hombre que se persigna antes de entrar al telo',1),
('w',297,'El Grinch',1),
('w',298,'Una faja que retiene mis órganos',1),
('w',299,'El chino que vende de todo',1),
('w',300,'Un voto nulo con un pene dibujado',1),
('w',301,'Las hemorroides',1),
('w',302,'Una ensalada rusa del siglo pasado',1),
('w',303,'La crisis de los cuarenta de mi viejo',1),
('w',304,'Un serenazgo que llegó al exorcismo',1),
('w',305,'Una declaración jurada de fidelidad',1),
('w',306,'Una chompa tejida con vello púbico',1),
('w',307,'Un abogado que se demandó a sí mismo',1),
('w',308,'Un pezón con complejo de superioridad',1),
('w',309,'Un frasco de champú lleno de sospechas',1),
('w',310,'Una llamada de RENIEC para confirmar mi defunción',1),
('w',311,'El papá de Peppa Pig',1),
('w',312,'Una paloma que cagó en el féretro',1),
('w',313,'Un beso con sabor a ceviche',1),
('w',314,'Un Black Friday en la funeraria',1),
('w',315,'El agua de un jacuzzi de dudosa reputación',1),
('w',316,'Un cobrador que aparece hasta en mis sueños eróticos',1),
('w',317,'Una foto policial en lugar del carnet universitario',1),
('w',318,'Una letrina con vista al Misti',1),
('w',319,'Dos soles de pensión alimenticia',1),
('w',320,'Un premio de consolación por infertilidad',1),
('w',321,'Un pavo con necrosis',1),
('w',322,'El culo de Shrek',1),
('w',323,'Un vaso de leche que no salió de una vaca',1),
('w',324,'Una cita con el dentista sin anestesia',1),
('w',325,'La ex que todavía tiene mi Netflix',1),
('w',326,'Un pollo a la brasa hallado en la escena del crimen',1),
('w',327,'El aliento de un cadáver resucitado',1),
('w',328,'Una venganza con pruebas de WhatsApp',1),
('w',329,'Un muerto que se perdió su propio entierro',1),
('w',330,'Un olor a pescado en la sacristía',1),
('w',331,'Una infidelidad descubierta por el historial de Yape',1),
('w',332,'Un impuesto a la paja',1),
('w',333,'La monja que me enseñó religión',1),
('w',334,'Un hijo no reconocido',1),
('w',335,'Una pizza con placenta',1),
('w',336,'Un pedo en el ascensor',1),
('w',337,'Un examen de próstata de recuperación',1),
('w',338,'Un sacerdote haciendo stand-up',1),
('w',339,'Una pechuga con implantes de dudosa calidad',1),
('w',340,'Un prolapso en plena misa',1),
('w',341,'Un pedazo de placenta en el táper',1),
('w',342,'Una fila para confesarse por infidelidad',1),
('w',343,'Una costra que no debo arrancar',1),
('w',344,'La suegra de mi ex',1),
('w',345,'El almuerzo de la última cena recalentado',1),
('w',346,'Mi capacidad para tomar malas decisiones',1),
('w',347,'Un ovario con ansiedad',1),
('w',348,'Un ataúd con luces LED',1),
('w',349,'La gorra del Chavo del Ocho',1),
('w',350,'Un karaoke de gemidos',1),
('w',351,'Un palo de escoba requisado en el telo',1),
('w',352,'Un limón en el lugar equivocado',1),
('w',353,'El calzoncillo de la suerte',1),
('w',354,'La silicona de un culo clandestino',1),
('w',355,'Una misita por mi promedio',1),
('w',356,'Un chisme de cinco generaciones',1),
('w',357,'Un divorcio en pleno bautizo',1),
('w',358,'Un sobre de lubricante confundido con ketchup',1),
('w',359,'La vergüenza ajena',1),
('w',360,'Una multa por orinar en la calle',1),
('w',361,'Los pelos de la ducha',1),
('w',362,'Una rata que heredó mi puesto de trabajo',1),
('w',363,'La jubilación anticipada de mi pene',1),
('w',364,'Un minuto de silencio por mi virginidad',1),
('w',365,'La familia de mi sugar mommy',1),
('w',366,'Mi cara en la foto de la denuncia',1),
('w',367,'Una cumbia para invocar a los muertos',1),
('w',368,'Un cuy con la mirada de mi suegra',1),
('w',369,'Un parlante que reproduce los audios privados de mi viejo',1),
('w',370,'Una parrillada con la familia del difunto',1),
('w',371,'El culo de un santo de yeso',1),
('w',372,'Un vaso de cerveza con pelos flotando',1),
('w',373,'Mi fe en la humanidad',1),
('w',374,'Un practicante de la morgue en su primer día',1),
('w',375,'Una luna de miel en el último asiento de la combi',1),
('w',376,'Una fiesta de fin de ciclo con tres pruebas de embarazo',1),
('w',377,'Una tesis plagiada del manual del Kamasutra',1),
('w',378,'La contraseña de la cuenta secreta de mi papá',1),
('w',379,'El único amigo que no me debe pensión',1),
('w',380,'Una carta notarial de mi suegra',1),
('w',381,'Una cita doble con mi ex y su ex',1),
('w',382,'Un baño sin pestillo en una clínica de fertilidad',1),
('w',383,'Un pedo radiactivo en el último asiento de la combi',1),
('w',384,'Un negocio piramidal',1),
('w',385,'Mi foto de la ficha de desaparecidos',1),
('w',386,'Un pobre huevón',1),
('w',387,'El infierno',1),
('w',388,'Una prueba de embarazo comprada por error',1),
('w',389,'Una disculpa por escrito de mi pene',1),
('w',390,'El pezón de mi tío',1),
('w',391,'La falsa promesa de que solo será una chela',1),
('w',392,'Un vibrador de segunda mano en la feria del Altiplano',1),
('w',393,'La dignidad de un cachudo en la Plaza de Armas',1),
('w',394,'Una señora regateando el precio de su ataúd',1),
('w',395,'Una hamburguesa con un diente humano',1),
('w',396,'El olor del uniforme después de dos semanas',1),
('w',397,'Un velorio con Yape obligatorio',1),
('w',398,'Un panetón relleno de cenizas',1),
('w',399,'Un certificado de virginidad falsificado',1),
('w',400,'Un exorcismo a domicilio',1)
on conflict(kind,id) do update set body=excluded.body,picks=excluded.picks;
create or replace function csm.label(t text, r text, n int) returns text language plpgsql stable set search_path=pg_catalog,csm as $$
declare names text[]; z int; a int;
begin
 select array_agg(nick order by seat) into names from csm.players where room=r;
 z:=coalesce(cardinality(names),0); if z=0 then return t; end if;
 a:=greatest(n-1,0)%z;
 return replace(replace(replace(t,'{derecha}',names[(a+1)%z+1]),'{izquierda}',names[(a+z-1)%z+1]),'{mesa}',names[a+1]);
end $$;
create or replace function csm.draw_round(r text, increment_round boolean) returns void language plpgsql set search_path=pg_catalog,csm as $$
declare s csm.rooms%rowtype; p csm.players%rowtype; deck int[]; bd int[]; h int[];
begin
 select * into s from csm.rooms where code=r;
 delete from csm.votes where room=r; delete from csm.answers where room=r;
 deck:=s.white_deck; bd:=s.black_deck;
 if coalesce(cardinality(bd),0)=0 then select array_agg(id order by random()) into bd from csm.cards where kind='b'; end if;
 for p in select * from csm.players where room=r order by seat loop
   h:=p.hand;
   while cardinality(h)<10 loop
     if coalesce(cardinality(deck),0)=0 then
       select array_agg(c.id order by random()) into deck from csm.cards c where c.kind='w' and not(c.id=any(h)) and not exists(select 1 from csm.players pl where pl.room=r and c.id=any(pl.hand));
     end if;
     if coalesce(cardinality(deck),0)=0 then raise exception 'No quedan cartas suficientes'; end if;
     h:=array_append(h,deck[1]); deck:=coalesce(deck[2:cardinality(deck)],'{}'::int[]);
   end loop;
   update csm.players set hand=h,ack=false,swapped_ids='{}' where id=p.id;
 end loop;
 update csm.rooms set phase='pick', round_no=round_no+case when increment_round then 1 else 0 end, black_id=bd[1], black_deck=coalesce(bd[2:cardinality(bd)],'{}'::int[]), white_deck=deck,reveal_no=0,epoch=epoch+1,updated_at=now() where code=r;
end $$;
create or replace function csm.view_room(r text, who uuid) returns jsonb language plpgsql volatile set search_path=pg_catalog,csm as $$
declare s csm.rooms%rowtype; p csm.players%rowtype; q jsonb; pl jsonb; ans jsonb; h jsonb; count_p int; progress int; total int;
begin
 select * into s from csm.rooms where code=r;
 select * into p from csm.players where room=r and id=who;
 if not found then raise exception 'Sesión inválida o jugador retirado'; end if;
 select count(*) into count_p from csm.players where room=r;
 select coalesce(jsonb_agg(jsonb_build_object('id',x.id,'nick',x.nick,'score',x.score,'host',x.id=s.host,'ready',case s.phase when 'pick' then exists(select 1 from csm.answers a where a.player=x.id) when 'vote' then exists(select 1 from csm.votes v where v.player=x.id) else x.ack end) order by x.seat),'[]') into pl from csm.players x where x.room=r;
 select jsonb_build_object('id',c.id,'text',csm.label(c.body,r,s.round_no),'picks',c.picks) into q from csm.cards c where c.kind='b' and c.id=s.black_id;
 select coalesce(jsonb_agg(jsonb_build_object('id',c.id,'text',csm.label(c.body,r,s.round_no)) order by u.ord),'[]') into h from unnest(p.hand) with ordinality u(id,ord) join csm.cards c on c.kind='w' and c.id=u.id;
 select coalesce(jsonb_agg(jsonb_build_object('id',a.id,'own',a.player=who,'pos',a.pos,'texts',(select jsonb_agg(csm.label(c.body,r,s.round_no) order by u.ord) from unnest(a.cards) with ordinality u(id,ord) join csm.cards c on c.kind='w' and c.id=u.id)) || case when s.phase in ('results','finished') then jsonb_build_object('author',x.nick,'player',x.id,'points',a.points) else '{}'::jsonb end order by a.pos),'[]') into ans from csm.answers a join csm.players x on x.id=a.player where a.room=r and (s.phase in ('vote','results','finished') or (s.phase='reveal' and a.pos=s.reveal_no));
 select count(*) into total from csm.answers where room=r;
 if s.phase='pick' then progress:=total; elsif s.phase='vote' then select count(*) into progress from csm.votes where room=r; else select count(*) into progress from csm.players where room=r and ack; end if;
 return jsonb_build_object('code',r,'me',who,'host',s.host=who,'phase',s.phase,'round',s.round_no,'rounds',s.rounds,'epoch',s.epoch,'question',q,'players',pl,'hand',h,'swapsLeft',greatest(0,3-cardinality(p.swapped_ids)),'answers',ans,'reveal',s.reveal_no,'total',total,'progress',progress,'count',count_p,'ready',case s.phase when 'pick' then exists(select 1 from csm.answers where player=who) when 'vote' then exists(select 1 from csm.votes where player=who) else p.ack end);
end $$;
create or replace function public.csm_game(p_action text,p_code text default '',p_token text default '',p_data jsonb default '{}'::jsonb) returns jsonb language plpgsql security definer set search_path=pg_catalog,csm as $$
declare r text:=upper(trim(coalesce(p_code,''))); s csm.rooms%rowtype; p csm.players%rowtype; target uuid; nick_in text; seat_in int; n int; k int; chosen int[]; f uuid; g uuid; secret uuid; result jsonb; wd int[]; h int[]; drawn int; discarded int[];
begin
 if p_action='create' then
   nick_in:=trim(coalesce(p_data->>'nick','')); if char_length(nick_in) not between 1 and 20 then raise exception 'Nickname de 1 a 20 caracteres'; end if;
   k:=coalesce((p_data->>'rounds')::int,10); if k not between 1 and 30 then raise exception 'Elige entre 1 y 30 rondas'; end if;
   -- Las salas caducan tras 24 horas sin acciones.
   delete from csm.rooms where updated_at < now()-interval '24 hours';
   loop r:=upper(substr(replace(gen_random_uuid()::text,'-',''),1,6)); insert into csm.rooms(code,rounds) values(r,k) on conflict do nothing; exit when found; end loop;
   insert into csm.players(room,nick,seat) values(r,nick_in,1) returning * into p;
   update csm.rooms set host=p.id where code=r;
   return csm.view_room(r,p.id)||jsonb_build_object('token',p.token);
 end if;
 if r !~ '^[0-9A-F]{6}$' then raise exception 'Código de sala inválido'; end if;
 if p_action='state' then
   select * into p from csm.players where room=r and token::text=p_token;
   if not found then raise exception 'Sesión inválida o jugador retirado'; end if;
   return csm.view_room(r,p.id);
 end if;
 select * into s from csm.rooms where code=r for update;
 if not found then raise exception 'La sala no existe o caducó'; end if;
 if p_action='join' then
   if s.phase<>'lobby' then raise exception 'La partida ya comenzó'; end if;
   nick_in:=trim(coalesce(p_data->>'nick','')); if char_length(nick_in) not between 1 and 20 then raise exception 'Nickname de 1 a 20 caracteres'; end if;
   if exists(select 1 from csm.players where room=r and lower(nick)=lower(nick_in)) then raise exception 'Ese nickname ya está en uso'; end if;
   select count(*),coalesce(max(seat),0)+1 into n,seat_in from csm.players where room=r;
   if n>=12 then raise exception 'Sala llena (12 jugadores)'; end if;
   insert into csm.players(room,nick,seat) values(r,nick_in,seat_in) returning * into p;
   update csm.rooms set updated_at=now() where code=r;
   return csm.view_room(r,p.id)||jsonb_build_object('token',p.token);
 end if;
 select * into p from csm.players where room=r and token::text=p_token;
 if not found then raise exception 'Sesión inválida o jugador retirado'; end if;
 if p_action in ('submit','ack','vote','swap') and coalesce((p_data->>'epoch')::int,-1)<>s.epoch then return csm.view_room(r,p.id); end if;
 select count(*) into n from csm.players where room=r;
 if p_action='start' then
   if p.id<>s.host or s.phase not in ('lobby','finished') then raise exception 'Solo el anfitrión puede comenzar'; end if;
   if n<4 then raise exception 'Se necesitan al menos 4 jugadores'; end if;
   k:=coalesce((p_data->>'rounds')::int,s.rounds); if k not between 1 and 30 then raise exception 'Elige entre 1 y 30 rondas'; end if;
   update csm.players set score=0,hand='{}',ack=false where room=r;
   update csm.rooms set round_no=0,rounds=k,black_deck='{}',white_deck='{}' where code=r;
   perform csm.draw_round(r,true);
 elsif p_action='swap' then
   if s.phase<>'pick' or exists(select 1 from csm.answers where player=p.id) then raise exception 'Solo puedes cambiar cartas antes de enviar'; end if;
   if jsonb_typeof(p_data->'cards') is distinct from 'array' then raise exception 'Selección inválida'; end if;
   select array_agg(value::int order by ord) into chosen from jsonb_array_elements_text(p_data->'cards') with ordinality v(value,ord);
   k:=coalesce(cardinality(chosen),0);
   if k<1 or k>3-cardinality(p.swapped_ids) or (select count(distinct x) from unnest(chosen) x)<>k or not(chosen <@ p.hand) then raise exception 'Cambia hasta tres cartas por ronda, de tu propia mano'; end if;
   discarded:=p.swapped_ids||chosen;
   h:=array(select x from unnest(p.hand) with ordinality u(x,ord) where not(x=any(chosen)) order by ord);
   wd:=s.white_deck;
   -- No duplicar manos, respuestas en juego ni cartas descartadas esta ronda.
   wd:=array(select x from unnest(wd) with ordinality u(x,ord) where not(x=any(discarded)) and not exists(select 1 from csm.players pl where pl.room=r and (x=any(pl.hand) or x=any(pl.swapped_ids))) and not exists(select 1 from csm.answers a where a.room=r and x=any(a.cards)) order by ord);
   while cardinality(h)<10 loop
     if cardinality(wd)=0 then
       select coalesce(array_agg(c.id order by random()),'{}'::int[]) into wd from csm.cards c where c.kind='w' and not(c.id=any(h)) and not(c.id=any(discarded)) and not exists(select 1 from csm.players pl where pl.room=r and (c.id=any(pl.hand) or c.id=any(pl.swapped_ids))) and not exists(select 1 from csm.answers a where a.room=r and c.id=any(a.cards));
     end if;
     if cardinality(wd)=0 then raise exception 'No quedan cartas suficientes'; end if;
     drawn:=wd[1]; h:=array_append(h,drawn); wd:=coalesce(wd[2:cardinality(wd)],'{}'::int[]);
   end loop;
   update csm.players set hand=h,swapped_ids=discarded where id=p.id;
   update csm.rooms set white_deck=wd where code=r;
 elsif p_action='submit' then
   if s.phase<>'pick' then return csm.view_room(r,p.id); end if;
   if exists(select 1 from csm.answers where player=p.id) then return csm.view_room(r,p.id); end if;
   if jsonb_typeof(p_data->'cards') is distinct from 'array' then raise exception 'Selección inválida'; end if;
   select array_agg(value::int order by ord) into chosen from jsonb_array_elements_text(p_data->'cards') with ordinality v(value,ord);
   select picks into k from csm.cards where kind='b' and id=s.black_id;
   if coalesce(cardinality(chosen),0)<>k or (select count(distinct x) from unnest(chosen) x)<>k or not(chosen <@ p.hand) then raise exception 'Elige las cartas requeridas de tu mano'; end if;
   insert into csm.answers(room,player,cards) values(r,p.id,chosen);
   update csm.players set hand=array(select x from unnest(p.hand) with ordinality u(x,ord) where not(x=any(chosen)) order by ord) where id=p.id;
   if (select count(*) from csm.answers where room=r)=n then
     update csm.answers a set pos=t.pos from (select id,row_number() over(order by random())::int pos from csm.answers where room=r) t where a.id=t.id;
     update csm.players set ack=false where room=r;
     update csm.rooms set phase='reveal',reveal_no=1,epoch=epoch+1 where code=r;
   end if;
 elsif p_action='ack' then
   if s.phase not in ('reveal','results') then return csm.view_room(r,p.id); end if;
   update csm.players set ack=true where id=p.id;
   if not exists(select 1 from csm.players where room=r and not ack) then
     update csm.players set ack=false where room=r;
     if s.phase='reveal' then
       if s.reveal_no<n then update csm.rooms set reveal_no=reveal_no+1,epoch=epoch+1 where code=r;
       else update csm.rooms set phase='vote',epoch=epoch+1 where code=r; end if;
     else
       if s.round_no>=s.rounds then update csm.rooms set phase='finished',epoch=epoch+1 where code=r;
       else perform csm.draw_round(r,true); end if;
     end if;
   end if;
 elsif p_action='vote' then
   if s.phase<>'vote' then return csm.view_room(r,p.id); end if;
   if exists(select 1 from csm.votes where player=p.id) then return csm.view_room(r,p.id); end if;
   f:=(p_data->>'first')::uuid; g:=(p_data->>'second')::uuid;
   if (f is null and g is not null) or (f is not null and ((g is not null and f=g) or not exists(select 1 from csm.answers where id=f and room=r and player<>p.id))) or (g is not null and not exists(select 1 from csm.answers where id=g and room=r and player<>p.id)) then raise exception 'Vota por hasta dos respuestas ajenas diferentes, primero la favorita'; end if;
   insert into csm.votes(player,room,first_id,second_id) values(p.id,r,f,g);
   if (select count(*) from csm.votes where room=r)=n then
     update csm.answers a set points=(select count(*)*2 from csm.votes v where v.first_id=a.id)+(select count(*) from csm.votes v where v.second_id=a.id) where a.room=r;
     update csm.players x set score=x.score+a.points,ack=false from csm.answers a where a.room=r and a.player=x.id;
     update csm.rooms set phase='results',epoch=epoch+1 where code=r;
   end if;
 elsif p_action in ('kick','leave') then
   if p_action='kick' then
     if p.id<>s.host then raise exception 'Solo el anfitrión puede retirar jugadores'; end if;
     target:=(p_data->>'player')::uuid; if target=p.id then raise exception 'Usa salir de la sala'; end if;
   else target:=p.id; end if;
   if not exists(select 1 from csm.players where room=r and id=target) then return csm.view_room(r,p.id); end if;
   -- Se reinicia la ronda interrumpida sin asignar puntos extra; si quedan menos de 4, vuelta al lobby.
   delete from csm.players where room=r and id=target;
   n:=n-1;
   if n=0 then delete from csm.rooms where code=r; return jsonb_build_object('left',true); end if;
   if target=s.host then update csm.rooms set host=(select id from csm.players where room=r order by seat limit 1) where code=r; end if;
   if s.phase<>'lobby' and n<4 then
     delete from csm.votes where room=r; delete from csm.answers where room=r;
     update csm.players set score=0,hand='{}',ack=false where room=r;
     update csm.rooms set phase='lobby',round_no=0,black_id=null,black_deck='{}',white_deck='{}',reveal_no=0,epoch=epoch+1 where code=r;
   elsif s.phase in ('pick','reveal','vote') then perform csm.draw_round(r,false);
   elsif s.phase='results' then
     update csm.players set ack=false where room=r; update csm.rooms set epoch=epoch+1 where code=r;
   end if;
   if target=p.id then return jsonb_build_object('left',true); end if;
 else raise exception 'Acción desconocida'; end if;
 update csm.rooms set updated_at=now() where code=r;
 return csm.view_room(r,p.id);
end $$;
revoke all on function public.csm_game(text,text,text,jsonb) from public, anon, authenticated;
grant execute on function public.csm_game(text,text,text,jsonb) to anon, authenticated;
commit;
notify pgrst, 'reload schema';
