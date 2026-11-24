# CSM. — Cartas Sin Moral

Juego de cartas de humor peruano y arequipeño (18+), para 4–12 jugadores. 500 cartas: 100 negras (85 de una respuesta y 15 de dos), 400 blancas. Interfaz adaptable, tipografía Arial/Helvetica en peso grueso, cartas monocromas, detalles amarillos y rosados, animación de reparto, confeti y sonidos opcionales. El mazo es independiente de los PDF de inspiración; no contiene imágenes ni escaneos de estos.

## Antes de empezar
GitHub Pages aloja la interfaz, no la base de datos. Supabase aporta las salas, cartas privadas, sincronización y validación de puntuaciones. Necesitas cuenta GitHub y Supabase. Los planes gratuitos pueden ser suficientes para partidas pequeñas privadas; revisa sus límites y disponibilidad. No hay instalación para los invitados, solo navegador e internet. El proyecto aún no está desplegado: debes completar los pasos siguientes. **No publiques claves secretas.**

## 1. Crear la base de datos (Supabase)
1. Entra a https://supabase.com/dashboard e inicia sesión. Selecciona New project; elige organización (crea una si es necesario), nombre `csm`, contraseña de base de datos segura y región cercana. Mantén habilitada Data API si aparece esa opción.
2. Cuando el proyecto esté listo, abre **SQL Editor** → **New query**. Abre `setup.sql` de este ZIP con un editor de texto, copia TODO el contenido, pégalo en el editor SQL y pulsa **Run**. Debe terminar sin errores. Usa un proyecto dedicado, no una base ajena. Esta operación crea el esquema privado `csm`, las cartas y la función pública `csm_game`; no necesitas crear tablas manualmente.
3. (Recomendado) Abre otra consulta y ejecuta `PRUEBA_SERVIDOR.sql`. Si funciona, el mensaje NOTICE dice `CSM: PRUEBA OK` y se revierten los datos de prueba. Si da error, no continúes hasta resolverlo.
4. Abre **Connect** (o **Project Settings → API Keys**) y copia **Project URL**, con formato `https://xxxxxxxx.supabase.co`, y **Publishable key**, con formato `sb_publishable_...`. Si usas una clave legacy, solo la `anon` pública (no `service_role`). Nunca compartas contraseña de base de datos, `sb_secret_...` o `service_role`.
5. Abre `config.js` del ZIP en un editor y reemplaza los dos valores:

```js
window.CSM_CONFIG = {
  url: "https://xxxxxxxx.supabase.co",
  key: "sb_publishable_xxxxxxxxx"
};
```

No agregues barras extra, comillas dobles de más o espacios en la clave. Guarda. Esta clave es publicable: el acceso a las cartas privadas está validado en el servidor mediante tokens de sesión individuales, no con la clave pública. No necesitas habilitar email login ni crear usuarios manualmente.

## 2. Publicar en GitHub Pages
1. Descomprime `CSM_GitHub.zip` en tu computadora. Los archivos del juego deben estar directamente en la raíz del repositorio, no dentro de otra carpeta.
2. Ve a https://github.com/new, escribe `csm` como nombre, selecciona **Public** (para Pages en GitHub Free) y crea el repositorio. Un repo público expone el código y las cartas; no expone las manos privadas almacenadas en Supabase.
3. En el repositorio, pulsa **uploading an existing file** o **Add file → Upload files**. Selecciona `index.html`, `style.css`, `app.js`, `config.js` ya editado, `deck.js`, `README.md`, `CARTAS_CSM.txt`, `setup.sql`, `PRUEBA_SERVIDOR.sql` y `.nojekyll` si tu explorador muestra archivos ocultos (si no aparece, puedes crear ese archivo vacío después; no es imprescindible para estos nombres). Pulsa **Commit changes**. No subas el ZIP como único archivo.
4. Abre **Settings → Pages**. En **Build and deployment**, selecciona **Deploy from a branch**; rama `main` y carpeta `/(root)`. Pulsa **Save**. Si la rama tiene otro nombre, elige esa.
5. Cuando termine el despliegue (puedes revisar Actions), Pages mostrará **Visit site**. La URL típica es `https://TU-USUARIO.github.io/csm/`. Abre esa dirección. Si no ves cambios, recarga y revisa el commit y Actions.

## 3. Probar con amigos
1. Abre el enlace en cuatro dispositivos o cuatro perfiles de navegador independientes. No uses cuatro pestañas normales del mismo navegador porque comparten almacenamiento de sesión.
2. Anfitrión: escribe nickname, elige rondas y pulsa Crear sala. Comparte código de seis caracteres o enlace de invitación.
3. Amigos: abran el enlace, escriban su nickname y únanse. Cuando haya al menos cuatro, el anfitrión puede iniciar.
4. Confirmen que cada uno tiene 10 cartas y que la pregunta negra es la misma. Envíen las respuestas. Cada carta se revela simultáneamente en todos los dispositivos (mediante consultas periódicas de ~1,5 segundos; puede haber un pequeño retraso). La siguiente no aparece hasta que los cuatro confirmen.
5. Prueben cambiar 1, 2 o 3 cartas antes de enviar; cada ronda devuelve el cupo a 3. Voten por dos, una o ninguna respuesta ajena. Con cuatro jugadores se reparten entre 0 y 12 puntos por ronda. Confirmen los resultados para continuar. Al final gana la mayor puntuación; los empates comparten victoria.
6. Recarga un dispositivo en medio de la ronda para probar reconexión. El token de sesión se guarda localmente en ese navegador; no borres su almacenamiento. Si se pierde, no se puede recuperar el puesto únicamente con el nickname. El anfitrión puede retirar a un jugador bloqueado; si quedan al menos 4, una ronda en selección/revelación/voto se reinicia sin puntuación. Si quedan menos de 4 durante la partida, se vuelve al lobby y se reinicia el marcador. El anfitrión cambia si abandona voluntariamente.

## Cómo se juega
- No hay juez. Todos juegan todas las rondas. Se admiten 4 a 12 jugadores y 1 a 30 rondas; 5/10/15 sugeridas.
- Una carta negra pide una o dos respuestas; selecciona en el orden que quieres que aparezcan.
- Las combinaciones se revelan de una en una, anónimas para los demás. La aplicación espera confirmación de todos para pasar a la siguiente. Sin temporizador obligatorio.
- Votación privada: favorita +2, segunda +1, hasta dos distintas y ajenas, o ninguna; un solo voto vale +2. El servidor valida y suma; todos reciben sus puntos. Autores y resultados visibles solo al cerrar la votación.
- Se repone la mano hasta 10 al siguiente turno. No se repite carta negra hasta agotar el mazo; las blancas descartadas se reciclan cuando se agota el mazo, excluyendo manos en juego.
- Los marcadores `{derecha}`, `{izquierda}`, `{mesa}` eligen apodos respecto de un asiento de referencia que rota con la ronda; todos leen exactamente el mismo texto.
- Si la conexión se pierde, el cliente vuelve a consultar el estado. No se permite entrar a una partida comenzada sin su token. Salas con más de 24 horas sin acciones se eliminan cuando se crea otra sala.

- Hasta 3 cambios de cartas blancas por jugador y ronda antes de enviar.

## Demo local y límites
Pulsa **Probar con 3 bots** para jugar tres rondas sin servidor. Los bots eligen al azar; no es una partida en línea ni comparten sala. También puedes abrir `CSM_Demo.html` (archivo separado, todo incluido) en un navegador que permita archivos HTML locales. En Android, si el visor de archivos no ejecuta JavaScript, usa GitHub Pages.

La demo v1.1 permite probar el cambio de cartas y las tres modalidades de votación. El SQL incluye una migración compatible con v1.0: ejecútalo nuevamente sin partidas activas y reemplaza los archivos de GitHub (conserva tu config.js). La base SQL no se ha ejecutado en un proyecto Supabase real desde aquí; `PRUEBA_SERVIDOR.sql` y una partida de cuatro dispositivos son las verificaciones pendientes. No se afirma que el sitio esté publicado. Las salas por código no son autenticación de alta seguridad ni un sistema antiabuso público: la app está pensada para grupos de confianza. No compartas código de sala públicamente. Los invitados no necesitan cuenta; la clave publicable va en el frontend, los tokens privados de sesión no deben compartirse.

## Cambiar las cartas
`CARTAS_CSM.txt` es la lista legible. `deck.js` es el mazo de demo y `setup.sql` contiene el mazo del servidor. Si editas cartas, sincroniza ambos archivos respetando IDs y número de respuestas; ejecuta el SQL actualizado en Supabase y vuelve a subir `deck.js` a GitHub. Evita editar durante partidas activas. Para una actualización solo de estética, basta editar `style.css` y publicar los cambios.

Documentación oficial: https://supabase.com/docs/guides/getting-started/api-keys · https://supabase.com/docs/guides/database/functions · https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site
