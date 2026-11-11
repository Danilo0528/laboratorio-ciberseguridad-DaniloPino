# 🛡️ laboratorio-ciberseguridad-DaniloPino

**Estudiante:** Danilo Pino (dpino) · **Asignatura:** Seguridad en redes y aplicaciones web — Unidad 2
**Evidencia de Aprendizaje 2:** Demostración en vivo y evaluación de laboratorio en la nube

---

## ✅ Estado actual de la tarea

| # | Requisito de la actividad | Estado |
|---|---|---|
| 1 | Repositorio público con tu nombre | ✅ `laboratorio-ciberseguridad-DaniloPino` |
| 2 | Los 8 módulos con su código + `Dockerfile` | ✅ subidos en `main` |
| 3 | URL de la DMZ vinculada en los módulos 01–07 (Paso 3) | ✅ hecho |
| 4 | **Nombre del estudiante en todas las URLs de Render** | ✅ todos llevan `-dpino` |
| 5 | **Mensaje personalizado en el servidor DMZ** | ✅ *"Servidor DMZ Activo - Laboratorio de Danilo Pino (dpino)"* |
| 6 | Los 8 servicios desplegados y `Live` en Render | ✅ verificados (HTTP 200) |
| 7 | Inyección del proxy MITM funcionando | ✅ `<!-- [ALERTA MITM] ... -->` |
| 8 | Revisar los logs de cada módulo | ⬜ **PENDIENTE** |
| 9 | Grabar el video (máx. 7 minutos) | ⬜ **PENDIENTE** |
| 10 | Crear el PDF con los logs | ⬜ **PENDIENTE** |
| 11 | Entregar antes del martes 10 de nov, 23:59 | ⬜ **PENDIENTE** |

> **Tu laboratorio ya funciona.** Lo que falta es la evidencia: logs → video → PDF.

---

## 🌐 URLs de tus servicios (todas con tus iniciales)

| Módulo | Servicio en Render | URL pública |
|---|---|---|
| 00 · Servidor víctima | servidor-web-dmz-dpino | https://servidor-web-dmz-dpino.onrender.com |
| 01 · Ataque DoS | modulo-01-dos-dpino | https://modulo-01-dos-dpino.onrender.com |
| 02 · Escaneo de puertos | modulo-02-escaneo-dpino | https://modulo-02-escaneo-dpino.onrender.com |
| 03 · Fuerza bruta de rutas | modulo-03-fuerzabruta-dpino | https://modulo-03-fuerzabruta-dpino.onrender.com |
| 04 · Exfiltración DNS | modulo-04-exfiltracion-dpino | https://modulo-04-exfiltracion-dpino.onrender.com |
| 05 · Cadena de suministro | modulo-05-cadena-dpino | https://modulo-05-cadena-dpino.onrender.com |
| 06 · Credential stuffing | modulo-06-stuffing-dpino | https://modulo-06-stuffing-dpino.onrender.com |
| 07 · Proxy MITM | modulo-07-mitm-dpino | https://modulo-07-mitm-dpino.onrender.com |

---

## 📚 Qué hace cada módulo

| Carpeta | Tipo | Qué hace |
|---|---|---|
| `00-servidor-dmz` | **víctima** | Servidor web que muestra tu nombre. Es el objetivo de todos los demás. |
| `01-ataque-dos` | atacante | Envía **30 peticiones HTTP simultáneas** (ráfaga DoS) contra la DMZ. |
| `02-escaneo-puertos` | atacante | Escanea 6 puertos de la DMZ con `nc -zv` y reporta cuáles están abiertos. |
| `03-fuerza-bruta-rutas` | atacante | Fuerza 6 rutas sensibles (`/admin`, `/backup.zip`…) y registra el código HTTP. |
| `04-exfiltracion-dns` | atacante | Codifica un dato en Base64 y lo envía como **subdominio DNS** (exfiltración). |
| `05-cadena-suministro` | atacante | Detecta una dependencia maliciosa inyectada durante el build (supply chain). |
| `06-credential-stuffing` | atacante | Prueba 5 usuarios con `Authorization: Basic` contra la DMZ. |
| `07-proxy-mitm` | atacante | Proxy que intercepta, reenvía a la DMZ y **inyecta HTML** en la respuesta. |

**Clave para entender el lab:** los módulos 01–06 ejecutan su ataque **una sola vez, al arrancar el contenedor**. Después se quedan sirviendo una web en Python para que Render no los suspenda. Por eso la evidencia del ataque está en su **log de arranque**. El 07 sí ataca **cada vez que abres su URL**.

---

## 📋 PASO 1 — Verificar los logs (obligatorio, ~15 min)

**Dónde:** Dashboard de Render → clic en el **nombre del servicio** → pestaña **Logs** → filtro **Application** (ignora *Build* y *Deploy*, eso es ruido).

Son **8 pestañas distintas**, una por servicio:

| Servicio | Log que DEBE aparecer |
|---|---|
| **00** (víctima) | `Servidor DMZ iniciado y escuchando en el puerto 8080...` y, al correr los ataques, ráfagas de `GET / HTTP/1.1" 200` y `GET /admin ... 200` |
| **01** | `=== SIMULACIÓN: GENERANDO TRÁFICO MASIVO HTTP ===` … `=== PRUEBA FINALIZADA ===` |
| **02** | `=== INICIANDO ESCANEO DE PUERTOS... ===` + `Connection to servidor-web-dmz-dpino.onrender.com 443 port [tcp/https] succeeded!` (80 igual; 21/22/8080/3306 dan `failed` = **correcto, están cerrados**) |
| **03** | `Ruta probada: /admin -> Código de respuesta HTTP: 200` … y las 6 rutas |
| **04** | `Dato original: clave_secreta_banco_2026` + `Dato codificado: ...` + salida de `nslookup` con el subdominio |
| **05** | `[ALERTA DE SEGURIDAD] Se ha detectado una dependencia no autorizada...` + `[PAYLOAD ADVERSARIO] Dependencia maliciosa ejecutándose...` |
| **06** | `Probando usuario [admin] con clave [password123] -> Respuesta HTTP: 200` (× 5 usuarios) |
| **07** | `[MITM INTERCEPTADO] Petición entrante hacia la ruta: /` + `[CABECERAS INTERCEPTADAS] {...}` + `[MITM ALERTA] Respuesta modificada e inyectada con éxito.` |

**Si un log sale vacío o solo con líneas de build:** botón **Manual Deploy → Deploy latest commit**. El ataque se vuelve a ejecutar y la evidencia reaparece.

**Truco para el video:** deja abierto el log del **00** (pestaña *Application*) y luego haz *Manual Deploy* del **01** → verás llegar los `GET /` en vivo, que es exactamente *"cómo se reflejan los vectores de ataque en los registros de auditoría"*.

---

## 🎥 PASO 2 — Grabar el video (máx. 7 minutos)

**Herramienta:** OBS Studio (gratis) o `Win + G` (Xbox Game Bar).
**Antes de grabar:**
- Recorre los 8 servicios una vez para **despertarlos** (el plan Free duerme los servicios y la primera carga tarda 30–60 s).
- **Ctrl + `+`** dos veces en el navegador: URLs y logs **se tienen que leer** en el video.
- Abre de antemano las pestañas: GitHub, Dashboard de Render, DMZ, y los 8 servicios.

---

### 🎬 GUION COMPLETO — lo que dices en cada escena

*(Son ~700 palabras: hablando tranquilo queda en 6 minutos con pausas. No memorices: lee mientras haces los clics.)*

**▶ ESCENA 1 · 0:00–0:35 — El repositorio** *(muestra: GitHub, las 8 carpetas)*

> "Buenas, soy Danilo Pino. Este es mi repositorio **laboratorio-ciberseguridad-DaniloPino**, en GitHub, de acceso público. Tiene los ocho módulos del laboratorio: el cero, el servidor víctima en la DMZ, y del uno al siete los módulos atacantes: ataque de denegación de servicio, escaneo de puertos, fuerza bruta de rutas, exfiltración por DNS, manipulación de la cadena de suministro, credential stuffing y proxy man-in-the-middle. Cada módulo trae su `entrypoint.sh` o `app.py` y su `Dockerfile`."

**▶ ESCENA 2 · 0:35–1:15 — Dashboard de Render** *(muestra: Render, los 8 servicios en verde)*

> "Ahora en Render están los ocho servicios desplegados, todos **Live**. Fíjense en los nombres: `servidor-web-dmz-dpino`, `modulo-01-dos-dpino`, y así hasta el siete. **Todos llevan mis iniciales**, que es lo que exige la actividad para comprobar que yo los creé. Se conectaron al mismo repositorio de GitHub con Runtime Docker y Root Directory por carpeta."

**▶ ESCENA 3 · 1:15–2:00 — La DMZ con tu nombre** *(muestra: URL de la DMZ, zoom al título)*

> "Este es el servidor víctima, la DMZ, en `servidor-web-dmz-dpino.onrender.com`. Está en la **zona desmilitarizada**, o sea, expuesto en la nube, y es el objetivo de todos los demás módulos. Aquí se ve mi nombre: **'Servidor DMZ Activo - Laboratorio de Danilo Pino'**, que es el mensaje personalizado que pide la actividad. Este nodo va a recibir todos los ataques que vienen ahora."

**▶ ESCENA 4 · 2:00–2:45 — Logs del 00 (la víctima)** *(muestra: Logs del 00, filtro Application)*

> "Vamos a los registros de auditoría del servidor víctima. Con el filtro **Application** se ve el tráfico real: aquí están las peticiones **GET** con respuesta **200** que le llegan a la DMZ. Esto es lo que demuestra el objetivo de la actividad: **cómo se refleja el ataque en los logs**. La víctima no sabe quién la ataca, pero sí registra todo lo que recibe."

**▶ ESCENA 5 · 2:45–3:15 — Módulo 01, DoS** *(muestra: Logs del 01)*

> "Módulo uno: **ataque de denegación de servicio**. El script dispara **treinta peticiones HTTP simultáneas** contra la DMZ para intentar saturarla. En el log se ve la simulación corriendo, y en el log del cero, justo antes, se ve la ráfaga de peticiones llegando de golpe. Ese es el vector de ataque reflejado en la víctima."

**▶ ESCENA 6 · 3:15–3:45 — Módulo 02, escaneo** *(muestra: Logs del 02)*

> "Módulo dos: **escaneo de puertos** con `nc`. Se analizan los puertos 21, 22, 80, 443, 8080 y 3306. El resultado es el esperado en un entorno real: **443 y 80 responden `succeeded`, están abiertos**; los demás fallan, están **cerrados o filtrados**. Eso es reconocimiento: primero el atacante descubre qué tiene abierto la víctima."

**▶ ESCENA 7 · 3:45–4:15 — Módulo 03, rutas** *(muestra: Logs del 03)*

> "Módulo tres: **enumeración de rutas**. Se prueban rutas sensibles —`/admin`, `/config.php`, `/login`, `/secret`, `/backup.zip`— y se registra el código de respuesta de cada una. En el log del cero también aparecen esas peticiones entrando. Si alguna ruta devolviera 404, el atacante sabría que no existe; si devuelve 200, sigue ahí para explotarla."

**▶ ESCENA 8 · 4:15–4:45 — Módulo 04, DNS** *(muestra: Logs del 04)*

> "Módulo cuatro: **exfiltración por consultas DNS**. El dato sensible, `clave_secreta_banco_2026`, se codifica en **Base64** y se monta como subdominio de un dominio que controla el atacante. El servidor no ve nada sospechoso, pero **el dato salió en claro dentro de una consulta DNS**. Por eso la exfiltración DNS es tan difícil de detectar."

**▶ ESCENA 9 · 4:45–5:10 — Módulo 05, cadena de suministro** *(muestra: Logs del 05)*

> "Módulo cinco: **cadena de suministro**. Aquí el ataque no es de red, ocurre en la **construcción de la imagen**: una dependencia maliciosa se inyecta durante el build y se ejecuta con los privilegios del contenedor. El log lanza la alerta —`[ALERTA DE SEGURIDAD] dependencia no autorizada`— y muestra el payload corriendo. Es un vector puramente defensivo: verificar la integridad del artefacto."

**▶ ESCENA 10 · 5:10–5:35 — Módulo 06, credentials** *(muestra: Logs del 06)*

> "Módulo seis: **credential stuffing**. Se prueban cinco usuarios —admin, root, user, docente, gestor— con la clave `password123` usando cabecera **Authorization Basic**. Cada intento queda registrado con su código HTTP. Este es el ataque que más se ve en la vida real, y contra él se defiende con bloqueo por intentos y doble factor."

**▶ ESCENA 11 · 5:35–6:30 — Módulo 07, MITM** ⚠️ *usa **Ctrl + U*** *(muestra: URL del 07 → Ctrl+U → Ctrl+F)*

> "Y el módulo siete, el **proxy man-in-the-middle**. Lo primero: abro su URL y se ve **la página de la DMZ con mi nombre**, o sea, el proxy **interceptó y reenvió** la petición. Ahora, como la inyección es un **comentario HTML**, con Ctrl+F normal no aparece: presiono **Ctrl + U** para ver el código fuente, **Ctrl + F** y busco **ALERTA MITM**. Ahí está, resaltado al final: *'Este contenido fue alterado en tránsito por el Proxy Interceptor'*. El atacante modificó la respuesta en medio del recorrido."

**▶ ESCENA 12 · 6:30–7:00 — Cierre** *(muestra: Dashboard con las 8 en verde + el PDF)*

> "Para cerrar: los **ocho servicios desplegados, ejecutándose en la nube y con mis iniciales en cada URL**. El laboratorio quedó completo: un servidor víctima en la DMZ y siete vectores de ataque, cada uno evidenciado en sus registros de auditoría. Adjunto el **PDF con los logs** de cada una de las ejecuciones. Esto fue todo, gracias."

---

### ⏱️ Si te sobra tiempo, agrega estas ideas (sin pasarte de 7 min)

- *"Render usa el plan gratuito, así que los servicios se duermen sin tráfico; el primer acceso tarda unos segundos en despertarlos."*
- *"Todos los módulos corren en contenedores Docker: misma base, distinta herramienta."*
- *"Lo que aprendí: un ataque no deja de ser tráfico legítimo mal usado — por eso los logs son la primera línea de defensa."*
- *"La detección no está en impedir el ataque, sino en reconocer su firma en la auditoría."*

### 📏 Reglas de grabación

- Pantalla completa, mouse lento, **3 segundos de pausa** en cada cosa importante.
- Graba **de un tirón, sin cortes**. Si te pasas de 7 min, recorta pausas, nunca contenido.
- Si un servicio tarda en despertar, **espera a que cargue**, no lo saltes.
- Si sale la página de **"Verificación de seguridad"** de Cloudflare: espera 1–3 min y recarga **una sola vez** (no le des F5 seguido; también sirve ventana incógnita `Ctrl + Shift + N`).

---

## 📄 PASO 3 — El PDF con los logs (10 puntos)

1. Con los 8 servicios ya verificados, captura cada log: **`Win + Shift + S`** (recorte) o `PrtSc`.
2. En tu editor de imágenes/doc, pégalas en orden con un título: `01 - DoS`, `02 - Escaneo de puertos`…
3. Incluye **portada** con la URL de la DMZ mostrando tu nombre.
4. Captura también el **código fuente del Módulo 07** (**`Ctrl + U`** → `Ctrl + F` → `ALERTA MITM` resaltado).
5. Exporta: **Ctrl + P → Destino → Guardar como PDF**.
6. Súbelo a la plataforma junto con el video.

---

## ⚠️ Problemas comunes (no son errores)

| Síntoma | Causa | Solución |
|---|---|---|
| El servicio tarda 30–60 s en responder o dice "waking up" | Plan **Free** duerme los servicios sin tráfico | Esperar a que cargue, o visitarlo antes de grabar |
| `==> New primary port detected: 8080. Restarting deploy...` | Render detecta el puerto | **Normal**, solo reinicia el deploy |
| El log solo muestra `Cloning...`, `apk add...`, `exporting layers` | Estás en el filtro *Build/Deploy* | Cambia el filtro a **Application** |
| El log de un ataque salió vacío | Render limpió los logs en el último deploy | **Manual Deploy → Deploy latest commit** |
| En el formulario aparece `Start Command` con `bundle exec puma` | Render no detectó Docker | Pone **Runtime: Docker** y verifica el **Root Directory** |
| `nc: getaddrinfo failed` en el módulo 02 | El `HOST` tenía `https://` | Ya corregido en commit `01809d1` (vuelto al código original del gist) |
| Aparece *"Verificación de seguridad en curso"* de Cloudflare | El antibot de Render se activa por muchas peticiones seguidas | Esperar 1–3 min y recargar **una sola vez**; o ventana incógnita `Ctrl + Shift + N` |
| `Ctrl + F` no encuentra `ALERTA MITM` | Es un **comentario HTML**: no se pinta en la página | Abrir el código fuente con **`Ctrl + U`** y ahí sí buscar |

---

## 🧾 Historial de cambios al código (transparencia)

| Commit | Qué se hizo | Por qué |
|---|---|---|
| `ef7c460` | URL de la DMZ → `dpino` en 01, 02, 03, 04, 06, 07 + nombre *"Danilo Pino"* en el 00 + README | **Paso 3 de la guía** (vincular tu URL real) y **requisito de entrega** (mensaje personalizado) |
| `de18739` → revertido en `c39c269` | Se había hecho visible el log del DoS | El profesor indicó mantener el código original |
| `01809d1` | `HOST` del módulo 02 sin `https://` | Restaura el **código literal del gist** del profesor (con `https://`, `nc` no resolvía) |
