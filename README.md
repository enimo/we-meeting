
# We Meeting

A WebRTC meeting service using [mediasoup](https://mediasoup.org).


Try it online at https://meet.enimo.cn. You can add /roomname to the URL for specifying a room.



## Manual installation

* Prerequisites:
Currently we-meeting will only run on nodejs v13.x

```bash
$ sudo apt install git npm build-essential redis
```

* Clone the project:

```bash
$ git clone git@github.com:enimo/we-meeting.git
$ cd we-meeting
```

* Copy `server/config/config.example.js` to `server/config/config.js` :

```bash
$ cp server/config/config.example.js server/config/config.js
```

* Copy `app/public/config/config.example.js` to `app/public/config/config.js` :

```bash
$ cp app/public/config/config.example.js app/public/config/config.js
```

* Edit your two `config.js` with appropriate settings (listening IP/port, logging options, **valid** TLS certificate, don't forget ip setting in last section in server config: (webRtcTransport), etc).

* Set up the browser app:

```bash
$ cd app
$ npm install
```

* Set up the server:

```bash
$ cd ..
$ cd server
$ npm install
```

## Run it locally

* Run the Node.js server application in a terminal:

```bash
$ cd server
$ npm start
```
* Note: Do not run the server as root. If you need to use port 80/443 make a iptables-mapping for that or use systemd configuration for that.


* Run the Node.js app application in a terminal:

```bash
$ cd app
$ npm start
```
* Test your development service in a webRTC enabled browser: `https://localhost:3443/roomname`



## Deploy to production environment

### 1.Package static files

```
$ cd app
$ npm run build
```

or use `app-mgr.sh` (require `npm install -g forever`)

```
$ ./app-mgr.sh build
```

* This will build the client application and copy everythink to `server/public` from where the server can host client code to browser requests.

* And then, you can set the webserver (nginx etc) wwwroot directory to  `server/public`, default port `3443` which configured in `server/config/config.js : listeningPort`, and this port will be used by socket.io listen port (default port `443` in production). So you must configure a nginx proxy in production environment, set nginx https 443 redirect to socketio 3443 as below:

```
        location /socket.io/ {
            proxy_pass http://127.0.0.1:3443;
            proxy_http_version 1.1;  
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_read_timeout 86400;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Fowarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Fowarded-Proto $scheme;
            proxy_cache_bypass $http_upgrade;
            proxy_set_header X-NginX-Proxy true;
            proxy_redirect off;
        }

        location / {
            root $we-meet-path/server/public;
            try_files  $uri  $uri/  /index.html;
        }
        
```

### 2. Configuration server ip

* Edit the `server/config/config.js` line num nearly `370`, with appropriate settings listening IP. 


### 3. Start server.js

Run script manually

```bash
$ cd server
$ npm start
```

Or use shell `app-mgr.sh` (require `npm install -g forever`)

```
$ ./app-mgr.sh start
```
