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
**Antes de grabar:** recorre los 8 servicios una vez para **despertarlos** (el plan Free duerme los servicios y la primera carga tarda 30–60 s).

| # | Tiempo | Qué muestras en pantalla | Qué dices (o texto en pantalla) |
|---|---|---|---|
| 1 | 0:00–0:35 | GitHub → repo `laboratorio-ciberseguridad-DaniloPino` → 8 carpetas | *"Laboratorio de ciberseguridad de Danilo Pino, con los 8 módulos."* |
| 2 | 0:35–1:15 | Dashboard de Render → los 8 servicios en verde | *"Los 8 servicios desplegados en Render, todos con mis iniciales."* |
| 3 | 1:15–2:00 | Abres la DMZ y haces zoom (Ctrl +) al título | *"Servidor víctima DMZ activo, con mi nombre personalizado."* |
| 4 | 2:00–2:45 | Logs del **00** → filtro Application | *"Los registros del servidor muestran el tráfico recibido."* |
| 5 | 2:45–3:15 | Logs del **01** | *"Módulo 01: ráfaga de tráfico masivo (DoS)."* |
| 6 | 3:15–3:45 | Logs del **02** | *"Módulo 02: escaneo de puertos — 443 y 80 abiertos, el resto filtrados."* |
| 7 | 3:45–4:15 | Logs del **03** | *"Módulo 03: enumeración de rutas sensibles."* |
| 8 | 4:15–4:45 | Logs del **04** | *"Módulo 04: exfiltración de datos por consultas DNS."* |
| 9 | 4:45–5:10 | Logs del **05** | *"Módulo 05: dependencia maliciosa en la cadena de suministro."* |
| 10 | 5:10–5:35 | Logs del **06** | *"Módulo 06: credential stuffing sobre el servidor."* |
| 11 | 5:35–6:30 | Abres la URL del **07** → `Ctrl + F` → buscas `ALERTA MITM` | *"Módulo 07: proxy man-in-the-middle que intercepta e inyecta código en la respuesta."* |
| 12 | 6:30–7:00 | Dashboard con las 8 en verde + el PDF | *"Laboratorio completo en la nube. Adjunto el PDF con los logs."* |

**Reglas de grabación:**
- Pantalla completa, mouse lento, **3 segundos de pausa** en cada cosa importante.
- **Ctrl + `+`** para agrandar el navegador: las URLs y los logs **se tienen que leer** en el video.
- Graba **de un tirón, sin cortes**. Si te pasas de 7 min, recorta pausas, nunca contenido.
- No hace falta discurso memorizado: con nombrar el módulo y lo que muestra basta.
- Si un servicio tarda en despertar, **espera a que cargue**, no lo saltes.

---

## 📄 PASO 3 — El PDF con los logs (10 puntos)

1. Con los 8 servicios ya verificados, captura cada log: **`Win + Shift + S`** (recorte) o `PrtSc`.
2. En tu editor de imágenes/doc, pégalas en orden con un título: `01 - DoS`, `02 - Escaneo de puertos`…
3. Incluye **portada** con la URL de la DMZ mostrando tu nombre.
4. Exporta: **Ctrl + P → Destino → Guardar como PDF**.
5. Súbelo a la plataforma junto con el video.

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

---

## 🧾 Historial de cambios al código (transparencia)

| Commit | Qué se hizo | Por qué |
|---|---|---|
| `ef7c460` | URL de la DMZ → `dpino` en 01, 02, 03, 04, 06, 07 + nombre *"Danilo Pino"* en el 00 + README | **Paso 3 de la guía** (vincular tu URL real) y **requisito de entrega** (mensaje personalizado) |
| `de18739` → revertido en `c39c269` | Se había hecho visible el log del DoS | El profesor indicó mantener el código original |
| `01809d1` | `HOST` del módulo 02 sin `https://` | Restaura el **código literal del gist** del profesor (con `https://`, `nc` no resolvía) |
